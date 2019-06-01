FOVFunctions = {}

-- Return true if cell allows light to pass through
function FOVFunctions.lightCallback(fov, x, y)
    local t = Game.gameMap.tiles[y][x]
    return t and not t.blockSight
end

-- Callback for recompute
-- x - X position of cell
-- y - Y position of cell
-- r - Cell distance from center of FOV
-- v - The cell's visibility rating (from 0-1). How well can you see this cell?
function FOVFunctions.computeCallback(x, y, r, v)
    local t = Game.gameMap.tiles[y][x]
    if t then
        Game.fovMap[x..','..y] = v
    end
end

return FOVFunctions