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
            tiles[y][x] = Tile(true)
        end
    end

    return tiles
end

function GameMap:makeMap(maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom)
    local rooms = {}
    local numRooms = 0

    for _ = 1, maxRooms do
        -- Random width and height
        local w = randInt(roomMinSize, roomMaxSize)
        local h = randInt(roomMinSize, roomMaxSize)
        -- Random position
        local x = randInt(1, mapWidth - w)
        local y = randInt(1, mapHeight - h)

        local newRoom = Rect(x, y, w, h)

        -- Run through the other rooms and see if they intersect with this one
        local intersect = false
        for _, v in ipairs(rooms) do
            if newRoom:intersect(v) then
                intersect = true
                break
            end
        end

        if not intersect then
            -- paint to the map's tiles
            self:createRoom(newRoom)
            local center = newRoom:center()

            if numRooms == 0 then
                -- This is the first room, where the player starts.
                player.x = center.x
                player.y = center.y
            else
                -- All rooms after the first
                -- Connect it to the previous room with a tunnel.

                -- center coordinate of previous room.
                local prevCenter = rooms[#rooms]:center()

                -- flip a coin
                if randInt(0, 1) == 1 then
                    -- First move horizontally then vertically
                    self:createHTunnel(prevCenter.x, center.x, prevCenter.y)
                    self:createVTunnel(prevCenter.y, center.y, center.x)
                else
                    -- First move vertically then horizontally
                    self:createVTunnel(prevCenter.y, center.y, prevCenter.x)
                    self:createHTunnel(prevCenter.x, center.x, center.y)
                end
            end

            self:placeEntities(newRoom, entities, maxMonstersPerRoom)

            numRooms = numRooms + 1
            rooms[numRooms] = newRoom
        end
    end
end

function GameMap:createRoom(room)
    -- Go through the tiles in the rectangle and make them passable.
    for x = room.x1 + 1, room.x2 do
        for y = room.y1 + 1, room.y2 do
            self.tiles[y][x].blocked = false
            self.tiles[y][x].blockSight = false
        end
    end
end

-- Create horizontal tunnel
function GameMap:createHTunnel(x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
        self.tiles[y][x].blocked = false
        self.tiles[y][x].blockSight = false
    end
end

-- Create vertical tunnel
function GameMap:createVTunnel(y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
        self.tiles[y][x].blocked = false
        self.tiles[y][x].blockSight = false
    end
end

function GameMap:placeEntities(room, entities, maxMonstersPerRoom)
    -- Get a random number of monsters
    local numberOfMonsters = randInt(0, maxMonstersPerRoom)

    for _ = 1, numberOfMonsters do
        -- Choose a random location
        local x = randInt(room.x1 + 1, room.x2 - 1)
        local y = randInt(room.y1 + 1, room.y2 - 1)

        local collision = false
        for _, v in ipairs(entities) do
            if v.x == x and v.y == y then
                collision = true
                break
            end
        end

        if not collision then
            local monster
            if randInt(0, 100) < 80 then
                monster = Entity(
                    x,
                    y,
                    'o',
                    'light green',
                    'Orc',
                    true,
                    Fighter(10, 0, 3),
                    BasicMonster()
                )
            else
                monster = Entity(
                    x,
                    y,
                    'T',
                    'green',
                    'Troll',
                    true,
                    Fighter(16, 1, 4),
                    BasicMonster()
                )
            end

            entities[#entities+1] = monster
        end
    end
end

function GameMap:isBlocked(x, y)
    if self.tiles[y] and self.tiles[y][x] and self.tiles[y][x].blocked then
        return true
    end
    return false
end