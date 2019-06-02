RenderFunctions = {}

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
    terminal.color('white')
    terminal.print(1, screenHeight-2, string.format('HP: %02d/%02d', player.fighter.hp, player.fighter.maxHp))
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