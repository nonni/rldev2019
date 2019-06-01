RenderFunctions = {}

function RenderFunctions.renderAll(entities, gameMap, screenWidth, screenHeight)
    -- Draw all the tiles in the game map
    for y = 1, gameMap.height do
        for x = 1, gameMap.width do
            local wall = gameMap.tiles[y][x].blocked
            if wall then
                terminal.bkcolor(PALETTE['dark_wall'])
                terminal.print(x-1, y-1, ' ')
            else
                terminal.bkcolor(PALETTE['dark_ground'])
                terminal.print(x-1, y-1, ' ')
            end
        end
    end

    -- Draw all entities in the list
    for _, v in ipairs(entities) do
        RenderFunctions.drawEntity(v)
    end
end

function RenderFunctions.clearAll(entities)
    for _, v in ipairs(entities) do
        RenderFunctions.clearEntity(v)
    end
end

function RenderFunctions.drawEntity(entity)
    terminal.color(entity.color)
    terminal.print(entity.x - 1, entity.y - 1, entity.char)
end

function RenderFunctions.clearEntity(entity)
    terminal.print(entity.x - 1, entity.y - 1, ' ')
end

return RenderFunctions