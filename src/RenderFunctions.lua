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

function RenderFunctions.renderAll(entities, player, gameMap, fovMap, screenWidth, screenHeight)
    -- Draw all the tiles in the game map
    terminal.layer(0)
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
                terminal.print(x-1, y-1, ' ')
            else
                if fovMap[x..','..y] then
                    terminal.bkcolor(PALETTE['light_ground'])
                    gameMap.tiles[y][x].explored = true
                elseif gameMap.tiles[y][x].explored then
                    terminal.bkcolor(PALETTE['dark_ground'])
                else
                    terminal.bkcolor(PALETTE['dark_wall'])
                end
                terminal.print(x-1, y-1, ' ')
            end
        end
    end

    terminal.layer(1)
    -- Sort list by render order
    table.sort(entities, function (a,b) 
        if a.renderOrder == b.renderOrder then return a.createTime < b.createTime
        else return a.renderOrder < b.renderOrder end
    end)
    -- Draw all entities in the list
    for _, v in ipairs(entities) do
        RenderFunctions.drawEntity(v, fovMap)
    end

    terminal.layer(2)
    -- Draw UI
    RenderFunctions.renderBar(1, 1, Game.uiBarWidth, 'HP', player.fighter.hp, player.fighter.maxHp, 'light red', 'dark red', 2)
end

function RenderFunctions.clearAll(entities)
    terminal.layer(1)
    for _, v in ipairs(entities) do
        RenderFunctions.clearEntity(v)
    end
end

function RenderFunctions.drawEntity(entity, fovMap)
    if fovMap[entity.x..','..entity.y] then
        terminal.color(entity.color)
        terminal.print(entity.x - 1, entity.y - 1, entity.char)
    end
end

function RenderFunctions.clearEntity(entity)
    terminal.print(entity.x - 1, entity.y - 1, ' ')
end

return RenderFunctions