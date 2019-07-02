terminal = require 'BearLibTerminal'
ROT = require 'lib/rotLove/rot'
Object = require 'lib/classic/classic'
Persistence = require 'lib/persistence/persistence'
require 'src/Global'
require 'src/Utils'

Enums = require 'src/Enums'
FOVFunctions = require 'src/FOVFunctions'
InputHandler = require 'src/InputHandler'
RenderFunctions = require 'src/RenderFunctions'
DeathFunctions = require 'src/DeathFunctions'
ItemFunctions = require 'src/ItemFunctions'
LoaderFunctions = require 'src/LoaderFunctions/LoaderFunctions'
require 'src/Message'
require 'src/MessageLog'
require 'src/Menus'
require 'src/components/Fighter'
require 'src/components/ai'
require 'src/components/Item'
require 'src/components/Inventory'
require 'src/components/Stairs'
require 'src/components/Level'
require 'src/Rect'
require 'src/Entity'
require 'src/Tile'
require 'src/GameMap'

Game = require 'src/engine'

-- Seed random (os.time OK for now)
math.randomseed(os.time())

-- Initialize terminal
terminal.open()
terminal.set("window: size=80x50; font: img/Talryth-square-15x15.png, size=15x15, codepage=437");
terminal.set("input: filter=[keyboard,mouse]")
terminal.set("0xE000: img/menu_background1.png, resize=1200x750, resize-filter=bicubic, align=center;")

function main()
	local showMainMenu = true
	local showLoadErrorMessage = false
	Game.init()

	while true do
		if showMainMenu then
			terminal.layer(0)
			if showLoadErrorMessage then
				terminal.clear()
				terminal.print(40, 25, '[0xE000]')
				terminal.color('white')
				Menus.messageBox('[color=yellow]No save game to load!', 50, 80, 50)
			else
				terminal.print(40, 25, '[0xE000]')
				terminal.color('white')
				Menus.mainMenu(80, 50)
			end
			terminal.refresh()
			terminal.clear()

			while(terminal.has_input()) do
				local key = terminal.read()
				if key == terminal.TK_CLOSE then
					return
				elseif key == terminal.TK_ESCAPE or
					key == terminal.TK_C
				then
					if showLoadErrorMessage then
						showLoadErrorMessage = false
					else
						return
					end
				elseif key == terminal.TK_A then
					Game.init()
					showMainMenu = false
				elseif key == terminal.TK_B then
					Game.init()
					local dataFile = LoaderFunctions.loadGame()
					if not dataFile then
						showLoadErrorMessage = true
					else
						Game.player = dataFile.player
						Game.entities = dataFile.entities
						Game.gameMap = dataFile.gameMap
						Game.messageLog = dataFile.messageLog
						Game.state = dataFile.state
						print (Game.state)
						showMainMenu = false
					end
				end
			end
		else
			showLoadErrorMessage = false
			-- Initialize and start the game loop
			Game.gameloop()
			Game.cleanup()
			showMainMenu = true
		end
	end
end

main()

terminal.close()