RenderFunctions = {}

function RenderFunctions.renderAll(entities, gameMap, fovMap, screenWidth, screenHeight)
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
    -- Draw all entities in the list
    for _, v in ipairs(entities) do
        RenderFunctions.drawEntity(v, fovMap)
    end
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