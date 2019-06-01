terminal = require 'BearLibTerminal'
ROT = require 'lib/rotLove/rot'
Object = require 'lib/classic/classic'
require 'src/Global'
require 'src/Utils'

FOVFunctions = require 'src/FOVFunctions'
InputHandler = require 'src/InputHandler'
RenderFunctions = require 'src/RenderFunctions'
require 'src/Rect'
require 'src/Entity'
require 'src/Tile'
require 'src/GameMap'


Game = {}

function Game.init()
	-- Initialize the library
	Game.quit = false
	Game.screenWidth = 80
	Game.screenHeight = 50

	Game.mapWidth = 80
	Game.mapHeight = 45
	Game.roomMaxSize = 10
	Game.roomMinSize = 6
	Game.maxRooms = 30

	Game.STATES = {
		PLAYERS_TURN = 1,
		ENEMY_TURN = 2
	}

	Game.state = Game.STATES.PLAYERS_TURN

	Game.player = Entity(
		math.floor(Game.screenWidth / 2),
		math.floor(Game.screenHeight / 2),
		'@',
		'white',
		'Player',
		true
	)

	Game.maxMonstersPerRoom = 3

	Game.entities = {Game.player}

	-- Map stuff
	Game.gameMap = GameMap(Game.mapWidth, Game.mapHeight)
	Game.gameMap:makeMap(Game.maxRooms, Game.roomMinSize, Game.roomMaxSize, Game.mapWidth, Game.mapHeight, Game.player, Game.entities, Game.maxMonstersPerRoom)

	-- FOV stuff
	Game.fovAlgorithm = ROT.FOV.Bresenham:new(FOVFunctions.lightCallback)
	Game.fovRadius = 10
	Game.fovMap = {}
	Game.fovRecompute = true

	terminal.open()
	terminal.set("window: size=80x50; font: img/Talryth-square-15x15.png, size=15x15, codepage=437");
	-- m=ROT.Map.Arena:new(50, 20)
	--function callbak(x,y,val)
	--    terminal.print(x, y, val == 1 and '#' or '.')
	--end
	--m:create(callbak)
end

function Game.gameloop()
	terminal.refresh()

	while(not Game.quit) do
		-- Parse input
		while(terminal.has_input()) do
			local action = InputHandler.handleKeys(terminal.read())
			if action then
				if action[1] == 'move' and Game.state == Game.STATES.PLAYERS_TURN then
					local destX = Game.player.x + action[2][1]
					local destY = Game.player.y + action[2][2]
					if not Game.gameMap:isBlocked(destX, destY) then
						local target = Entity.getBlockingEntitiesAtLocation(Game.entities, destX, destY)
						if target then
							print('You kick the ' .. target.name .. 'in the shins, much to its annoyance!')
						else
							Game.player:move(action[2][1], action[2][2])
							Game.fovRecompute = true
						end

						Game.state = Game.STATES.ENEMY_TURN
					end
				elseif action[1] == 'exit' then
					Game.quit = true
					break
				elseif action[1] == 'fullscreen' then
					if terminal.check(terminal.TK_FULLSCREEN) then
						terminal.set('window: fullscreen=false')
					else
						terminal.set('window: fullscreen=false')
					end
				end
			end
		end

		-- Update stuff
		Game.update()

		-- Render
		Game.draw()
	end
end

function Game.update()
	if Game.fovRecompute then
		-- Recompute FOV.
		Game.fovMap = {}
		Game.fovAlgorithm:compute(Game.player.x, Game.player.y, Game.fovRadius, FOVFunctions.computeCallback)
		Game.fovRecompute = false
	end

	if Game.state == Game.STATES.ENEMY_TURN then
		for _, v in ipairs(Game.entities) do
			if v.name ~= 'Player' then
				print('The ' .. v.name .. ' ponders the meaning of its existence')
				Game.state = Game.STATES.PLAYERS_TURN
			end
		end
	end
end

function Game.draw()
	-- Print something
	RenderFunctions.renderAll(Game.entities, Game.gameMap, Game.fovMap, Game.screenWidth, Game.screenHeight)
	terminal.refresh()
	RenderFunctions.clearAll(Game.entities)
end

function Game.cleanup()
	terminal.close()
end

Game.init()
Game.gameloop()
Game.cleanup()


