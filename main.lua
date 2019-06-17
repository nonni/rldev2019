terminal = require 'BearLibTerminal'
ROT = require 'lib/rotLove/rot'
Object = require 'lib/classic/classic'
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
require 'src/Rect'
require 'src/Entity'
require 'src/Tile'
require 'src/GameMap'

Game = require 'src/engine'

Game.init()
Game.gameloop()
Game.cleanup()


