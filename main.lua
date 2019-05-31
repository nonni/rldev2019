terminal = require 'BearLibTerminal'
InputHandler = require 'src/input_handlers'
--ROT = require 'lib/rotLove/rot'

Game = {}

function Game.init()
	-- Initialize the library
	Game.quit = false
	Game.screen_width = 80
	Game.screen_height = 50

	Game.player_x = math.floor(Game.screen_width / 2)
	Game.player_y = math.floor(Game.screen_height / 2)

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
					Game.player_x = Game.player_x + action[2][1]
					Game.player_y = Game.player_y + action[2][2]
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
	terminal.print(Game.player_x, Game.player_y, '@')
	terminal.refresh()
	terminal.print(Game.player_x, Game.player_y, ' ')
end

function Game.cleanup()
	terminal.close()
end

Game.init()
Game.gameloop()
Game.cleanup()


