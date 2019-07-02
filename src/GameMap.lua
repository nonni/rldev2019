GameMap = Object:extend()

function GameMap:new(width, height, dungeonLevel)
    self.width = width
    self.height = height
    self.tiles = self:initializeTiles()

    self.dungeonLevel = dungeonLevel or 1
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

function GameMap:makeMap(maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom, maxItemsPerRoom)
    local rooms = {}
    local numRooms = 0

    local centerOfLastRoom = {}

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

                centerOfLastRoom.x = prevCenter.x
                centerOfLastRoom.y = prevCenter.y

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

            self:placeEntities(newRoom, entities, maxMonstersPerRoom, maxItemsPerRoom)

            numRooms = numRooms + 1
            rooms[numRooms] = newRoom
        end
    end

    print('Stairs: '..centerOfLastRoom.x..','..centerOfLastRoom.y)
    local downStairs = Entity(
        centerOfLastRoom.x,
        centerOfLastRoom.y,
        '>',
        'white',
        'Stairs',
        {
            stairs = Stairs(self.dungeonLevel + 1),
            renderOrder = Enums.RenderOrder.STAIRS
        })
    table.insert(entities, downStairs)
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

function GameMap:placeEntities(room, entities, maxMonstersPerRoom, maxItemsPerRoom)
    -- Get a random number of monsters
    local numberOfMonsters = randInt(0, maxMonstersPerRoom)
    local numberOfItems = randInt(0, maxItemsPerRoom)

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
                    PALETTE['light_green'],
                    'Orc',
                    {
                        blocks = true,
                        renderOrder = Enums.RenderOrder.ACTOR,
                        fighter = Fighter(10, 0, 3),
                        ai = BasicMonster()
                    }
                )
            else
                monster = Entity(
                    x,
                    y,
                    'T',
                    PALETTE['dark_green'],
                    'Troll',
                    {
                        blocks = true,
                        renderOrder = Enums.RenderOrder.ACTOR,
                        fighter = Fighter(16, 1, 4),
                        ai = BasicMonster()
                    }
                )
            end

            entities[#entities+1] = monster
        end
    end

    for _ = 1, numberOfItems do
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
            local itemChance = randInt(0, 100)
            local item

            if itemChance < 70 then
                -- Healing potion
                item = Entity(
                    x,
                    y,
                    '!',
                    PALETTE['light_blue'],
                    'Healing potion',
                    {
                        renderOrder = Enums.RenderOrder.ITEM,
                        item = Item(ItemFunctions.heal, {amount = 4, functionName = 'heal'})
                    }
                )
            elseif itemChance < 80 then
                -- Fireball scroll
                item = Entity(
                    x,
                    y,
                    '#',
                    'red',
                    'Fireball Scroll',
                    {
                        renderOrder = Enums.RenderOrder.ITEM,
                        item = Item(ItemFunctions.castFireball, {functionName = 'castFireball', targeting = true, targeting_message = Message('Left-click a target tile for the fireball, or right-click to cancel.', PALETTE['light_cyan']), damage = 12, radius = 3})
                    }
                )
            elseif itemChance < 90 then
                -- Confusion scroll
                item = Entity(
                    x,
                    y,
                    '#',
                    'pink',
                    'Confusion Scroll',
                    {
                        renderOrder = Enums.RenderOrder.ITEM,
                        item = Item(ItemFunctions.castConfuse, {functionName = 'castConfuse', targeting = true, targeting_message = Message('Left-click an enemy to confuse it, or right-click to cancel.', PALETTE['light_cyan'])})
                    }
                )
            else
                -- Scroll
                item = Entity(
                    x,
                    y,
                    '#',
                    'yellow',
                    'Lightning Scroll',
                    {
                        renderOrder = Enums.RenderOrder.ITEM,
                        item = Item(ItemFunctions.castLightning, {functionName = 'castLightning', damage = 20, maximum_range=5})
                    }
                )
            end
            entities[#entities+1] = item
        end
    end
end

function GameMap:isBlocked(x, y)
    if self.tiles[y] and self.tiles[y][x] and self.tiles[y][x].blocked then
        return true
    end
    return false
end

function GameMap:nextFloor(maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, maxMonstersPerRoom, maxItemsPerRoom, messageLog)
    self.dungeonLevel = self.dungeonLevel + 1
    local entities = {}
    table.insert(entities, player)
    self.tiles = self:initializeTiles()
    self:makeMap(maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom, maxItemsPerRoom)
    player.fighter:heal(player.fighter.maxHp / 2)
    messageLog:addMessage(Message('You take a moment to rest, and recover your strength.', 'violet'))
    return entities
end