GameMap = Object:extend()

function GameMap:new(width, height)
    self.width = width
    self.height = height
    self.tiles = self:initializeTiles()
end

function GameMap:initializeTiles()
    local tiles = {}
    for y = 1, self.height do
        tiles[y] = {}
        for x = 1, self.width do
            tiles[y][x] = Tile(false)
        end
    end

    tiles[30][22].blocked = true
    tiles[31][22].blocked = true
    tiles[32][22].blocked = true

    return tiles
end

function GameMap:isBlocked(x, y)
    if self.tiles[y][x].blocked then
        return true
    end

    return false
end