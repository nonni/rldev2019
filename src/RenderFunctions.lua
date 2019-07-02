RenderFunctions = {}

function RenderFunctions.renderBar(x, y, totalWidth, name, value, maximum, barColor, backColor, layer)
    local barWidth = math.ceil(value / maximum * totalWidth)

    terminal.layer(layer)
    -- Panel background.
    terminal.print(x, y, string.format('[color=%s]%s', backColor, string.rep('▒', totalWidth)))
    -- Panel fill
    terminal.print(x, y, string.format('[color=%s]%s', barColor, string.rep('█', barWidth)))
    -- Panel text
    terminal.layer(layer+1)
    local text = string.format('[color=white]%s: %d/%d', name, value, maximum)
    terminal.clear_area(math.floor(x + totalWidth / 2), y, #text, 1)
    terminal.print(math.floor(x + totalWidth / 2), y, text)
end

function RenderFunctions.getNamesUnderMouse(mouseX, mouseY, entities, fovMap)
    local names = ''
    for _,entity in ipairs(entities) do
        if (entity.x == mouseX + 1 and entity.y == mouseY + 1 and fovMap[entity.x..','..entity.y]) then
            names = names .. ', ' .. entity.name
        end
    end

    return string.sub(string.upper(names), 3)
end

function RenderFunctions.renderAll(entities, player, gameMap, fovMap, messageLog, screenWidth, screenHeight, gameState)
    -- Draw all the tiles in the game map
    terminal.layer(Enums.Layers.DUNGEON)
    local dy = screenHeight - gameMap.height - 1
    for y = 1, gameMap.height do
        for x = 1, gameMap.width do
            local wall = gameMap.tiles[y][x].blocked
            if wall then
                if fovMap[x..','..y] then
                    terminal.bkcolor(PALETTE['light_wall'])
                    gameMap.tiles[y][x].explored = true
                else
                    terminal.bkcolor(PALETTE['dark_wall'])
                end
                terminal.print(x-1, y+dy, ' ')
            else
                if fovMap[x..','..y] then
                    terminal.bkcolor(PALETTE['light_ground'])
                    gameMap.tiles[y][x].explored = true
                elseif gameMap.tiles[y][x].explored then
                    terminal.bkcolor(PALETTE['dark_ground'])
                else
                    terminal.bkcolor(PALETTE['dark_wall'])
                end
                terminal.print(x-1, y+dy, ' ')
            end
        end
    end

    terminal.layer(Enums.Layers.ENTITIES)
    -- Sort list by render order
    table.sort(entities, function (a,b)
        if a.renderOrder == b.renderOrder then return a.createTime < b.createTime
        else return a.renderOrder < b.renderOrder end
    end)
    -- Draw all entities in the list
    for _, v in ipairs(entities) do
        RenderFunctions.drawEntity(v, fovMap, gameMap, dy)
    end

    terminal.layer(Enums.Layers.UI)
    -- Draw UI
    RenderFunctions.renderBar(1, 1, Game.uiBarWidth, 'HP', player.fighter.hp, player.fighter.maxHp, PALETTE['red'], PALETTE['violet'], 2)

    terminal.print(1, 3, 'Dungeon level: ' .. gameMap.dungeonLevel)

    local names = RenderFunctions.getNamesUnderMouse(
        terminal.state(terminal.TK_MOUSE_X),
        terminal.state(terminal.TK_MOUSE_Y) - dy - 1,
        entities,
        fovMap
    )
    terminal.clear_area(1, 0, screenWidth, 1)
    terminal.print(1, 0, '[color=white]'..names)

    -- Print the game messages, one line at a time
    local y = 1
    terminal.clear_area(messageLog.x, y, messageLog.width, messageLog.height)
    for _,message in ipairs(messageLog.messages) do
        terminal.print(messageLog.x, y, string.format('[color=%s]%s', message.color, message.text))
        y = y + 1
    end

    -- Display inventory if game state is show inventory.
    if gameState == Enums.States.SHOW_INVENTORY or gameState == Enums.States.DROP_INVENTORY then
        local inventoryTitle
        terminal.color('white')
        if gameState == Enums.States.SHOW_INVENTORY then
            inventoryTitle = 'Press the key next to an item to use it, or Esc to cancel.'
        else
            inventoryTitle = 'Press the key next to an item to drop it, or Esc to cancel.'
        end
        Menus.inventoryMenu(
            Enums.Layers.INVENTORY,
            inventoryTitle,
            Game.player.inventory,
            50,
            screenWidth,
            screenHeight
        )
    end
end

-- Clear rectangle from layer
function RenderFunctions.clearLayer(layer, x, y, width, height)
    terminal.layer(layer)
    terminal.clear_area(x, y, width, height)
end

function RenderFunctions.clearAll(entities, dy)
    terminal.layer(Enums.Layers.ENTITIES)
    for _, v in ipairs(entities) do
        RenderFunctions.clearEntity(v, dy)
    end
end

function RenderFunctions.rectangle(layer, color, x, y, w, h, char)
    char = char or '█'
    terminal.layer(layer)
    for curY = 0,h do
        terminal.print(x, y + curY, string.format('[color=%s]%s', color, string.rep(char, w)))
    end
end


function RenderFunctions.drawEntity(entity, fovMap, gameMap, dy)
    if fovMap[entity.x..','..entity.y] or (entity.stairs and gameMap.tiles[entity.y][entity.x].explored) then
        terminal.color(entity.color)
        terminal.print(entity.x - 1, entity.y + dy, entity.char)
    end
end

function RenderFunctions.clearEntity(entity, dy)
    terminal.print(entity.x - 1, entity.y + dy, ' ')
end

return RenderFunctions