function LoaderFunctions.setGameConstants(gameObject)
    gameObject.quit = false
	gameObject.screenWidth = 80
	gameObject.screenHeight = 50

	gameObject.mapWidth = 80
	gameObject.mapHeight = 43
	gameObject.roomMaxSize = 10
	gameObject.roomMinSize = 6
	gameObject.maxRooms = 30

	gameObject.uiBarWidth = 20
	gameObject.uiPanelHeight = 7
	gameObject.uiPanelY = gameObject.screenHeight - gameObject.uiPanelHeight

	gameObject.uiMessageX = gameObject.uiBarWidth + 2
	gameObject.uiMessageWidth = gameObject.screenWidth - gameObject.uiBarWidth - 2
    gameObject.uiMessageHeight = gameObject.uiPanelHeight - 1

    gameObject.maxMonstersPerRoom = 3
    gameObject.maxItemsPerRoom = 2

    -- FOV stuff
	gameObject.fovAlgorithm = ROT.FOV.Bresenham:new(FOVFunctions.lightCallback)
	gameObject.fovRadius = 10
	gameObject.fovMap = {}
	gameObject.fovRecompute = true
end

function LoaderFunctions.initializeGameVariables(gameObject)
    gameObject.messageLog = MessageLog(gameObject.uiMessageX, gameObject.uiMessageWidth, gameObject.uiMessageHeight)

	gameObject.state = Enums.States.PLAYERS_TURN
	gameObject.previousState = gameObject.state

	gameObject.player = Entity(
		math.floor(gameObject.screenWidth / 2),
		math.floor(gameObject.screenHeight / 2),
		'@',
		'white',
		'Player',
		{
			blocks = true,
			renderOrder = Enums.RenderOrder.ACTOR,
			fighter = Fighter(30, 2, 5),
			inventory = Inventory(26)
		}
	)

	gameObject.entities = {gameObject.player}

	-- Map stuff
	gameObject.gameMap = GameMap(gameObject.mapWidth, gameObject.mapHeight)
	gameObject.gameMap:makeMap(
		gameObject.maxRooms,
		gameObject.roomMinSize,
		gameObject.roomMaxSize,
		gameObject.mapWidth,
		gameObject.mapHeight,
		gameObject.player,
		gameObject.entities,
		gameObject.maxMonstersPerRoom,
		gameObject.maxItemsPerRoom
    )
end

return LoaderFunctions