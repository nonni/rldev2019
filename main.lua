terminal = require 'BearLibTerminal'
--ROT = require 'lib/rotLove/rot'

Game = {}

function Game.init()
	-- Initialize the library
	Game.quit = false
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
			local key = terminal.read()
			print (key)
			if (key == terminal.TK_ESCAPE) then
				Game.quit = true
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
	terminal.print(2, 1, '@')
	terminal.refresh()
end

function Game.cleanup()
	terminal.close()
end

Game.init()
Game.gameloop()
Game.cleanup()


