
function LoaderFunctions.saveGame(player, entities, gameMap, messageLog, gameState)
    local dataFile = {
        player = player,
        entities = entities,
        gameMap = gameMap,
        messageLog = messageLog,
        state = gameState
    }

    Persistence.store('savegame.lua', dataFile)
end

function LoaderFunctions.loadGame()
    local dataFile = Persistence.load('savegame.lua')
    local gameObjects = {}

    if not dataFile then
        return
    end

    -- MessageLog.
    gameObjects['messageLog'] = MessageLog(
        dataFile.messageLog.x,
        dataFile.messageLog.width,
        dataFile.messageLog.height
    )
    gameObjects['messageLog'].messages = dataFile.messageLog.messages

    -- GameMap
    gameObjects['gameMap'] = GameMap(dataFile.gameMap.width, dataFile.gameMap.height)
    gameObjects['gameMap'].tiles = dataFile.gameMap.tiles

    --x, y, char, color, name, opts
    -- Player
    gameObjects['player'] = LoaderFunctions.RemakeEntity(dataFile.player)

    -- Entities
    gameObjects['entities'] = {}
    for _,e in ipairs(dataFile.entities) do
        if e.name == 'Player' then
            table.insert(gameObjects['entities'], gameObjects['player'])
        else
            table.insert(gameObjects['entities'], LoaderFunctions.RemakeEntity(e))
        end
    end

    gameObjects['state'] = dataFile.state

    return gameObjects
end

function LoaderFunctions.RemakeEntity(data)
    -- Fighter
    local fighter
    if data.fighter then
        fighter = Fighter(data.fighter.maxHp, data.fighter.defense, data.fighter.power)
        fighter.hp = data.fighter.hp
    end

    -- AI
    local ai
    if data.ai and data.ai.name == 'BasicMonster' then
        ai = BasicMonster()
    elseif data.ai and data.ai.name == 'ConfusedMonster' then
        if data.ai.previousAI.name == 'BasicMonster' then
            ai = ConfusedMonster(BasicMonster(), data.ai.numberOfTurns)
        end
    end

    -- Item
    local item
    if data.item then
        local tmpOpts = data.item.defaultOpts
        if tmpOpts.targetingMessage then
            tmpOpts.targetingMessage = Message(tmpOpts.targetingMessage.text, tmpOpts.targetingMessage.color)
        end
        item = Item(ItemFunctions[data.item.functionName], tmpOpts)
    end

    -- Inventory
    local inventory
    if data.inventory then
        inventory = Inventory(data.inventory.capacity)
        for _, v in ipairs(data.inventory.items) do
            table.insert(inventory.items, LoaderFunctions.RemakeEntity(v))
        end
    end

    -- Stairs
    local stairs
    if data.stairs then
        stairs = Stairs(data.stairs.floor)
    end

    return Entity(
        data.x,
        data.y,
        data.char,
        data.color,
        data.name,
        {
            blocks = data.blocks,
            renderOrder = data.renderOrder,
            id = data.id,
            createTime = data.createTime,
            fighter = fighter,
            ai = ai,
            item = item,
            inventory = inventory,
            stairs = stairs
        }
    )
end
