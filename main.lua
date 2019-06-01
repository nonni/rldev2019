terminal = require 'BearLibTerminal'
Object = require 'lib/classic/classic'
require 'src/Global'

InputHandler = require 'src/InputHandler'
RenderFunctions = require 'src/RenderFunctions'
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

	Game.player = Entity(
		math.floor(Game.screenWidth / 2),
		math.floor(Game.screenHeight / 2),
		'@',
		'white'
	)

	Game.npc = Entity(
		math.floor(Game.screenWidth / 2) - 5,
		math.floor(Game.screenHeight / 2),
		'@',
		'249,215,28'
	)

	Game.gameMap = GameMap(Game.mapWidth, Game.mapHeight)

	Game.entities = {Game.player, Game.npc}

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
				if action[1] == 'move' then
					if not Game.gameMap:isBlocked(Game.player.x + action[2][1], Game.player.y + action[2][2]) then
						Game.player:move(action[2][1], action[2][2])
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

end

function Game.draw()
	-- Print something
	RenderFunctions.renderAll(Game.entities, Game.gameMap, Game.screenWidth, Game.screenHeight)
	terminal.refresh()
	RenderFunctions.clearAll(Game.entities)
end

function Game.cleanup()
	terminal.close()
end

Game.init()
Game.gameloop()
Game.cleanup()


