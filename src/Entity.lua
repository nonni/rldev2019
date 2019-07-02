Entity = Object:extend()

function Entity:new(x, y, char, color, name, opts)
    -- Assign opts variables as self.[key].
    local iopts = opts or {}
    if iopts then for k, v in pairs(iopts) do self[k] = v end end

    self.x, self.y = x, y
    self.char = char
    self.color = color
    self.name = name
    -- Opts
    self.blocks = self.blocks or false
    self.renderOrder = self.renderOrder or Enums.RenderOrder.Actor

    self.id = UUID()
    self.createTime = os.clock()

    if self.fighter then
        self.fighter.owner = self
    end

    if self.ai then
        self.ai.owner = self
    end

    if self.item then
        self.item.owner = self
    end

    if self.inventory then
        self.inventory.owner = self
    end

    if self.stairs then
        self.stairs.owner = self
    end

    if self.level then
        self.level.owner = self
    end
end

function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Entity.getBlockingEntitiesAtLocation(entities, x, y)
    for _, v in ipairs(entities) do
        if v.blocks and v.x == x and v.y == y then
            return v
        end
    end

    return nil
end

function Entity:moveTowards(targetX, targetY, gameMap, entities)
    local dx = targetX - self.x
    local dy = targetY - self.y
    local distance = math.sqrt((dx^2) + (dy^2))

    dx = math.floor(round(dx / distance))
    dy = math.floor(round(dy / distance))

    if not (gameMap:isBlocked(self.x + dx, self.y + dy) or
            Entity.getBlockingEntitiesAtLocation(entities, self.x + dx, self.y + dy)) then
        self:move(dx, dy)
    end
end

function Entity:distanceTo(other)
    local dx = other.x - self.x
    local dy = other.y - self.y
    return math.sqrt((dx^2) + (dy^2))
end

function Entity:moveAStar(target, gameMap, entities)
    -- Check if position is passable.
    local function passableCallback(x, y)
        if gameMap:isBlocked(x,y) then
            return false
        end
        -- Unable to pass entities blocking entities.
        -- Ignore self and target.
        for _,v in ipairs(entities) do
            if v.blocks and v.id ~= self.id and v.id ~= target.id and v.x == x and v.y == y then
                return false
            end
        end

        return true
    end

    -- Callback from A* algorithm.
    local path = {}
    local function astarCallback(x, y)
        path[#path + 1] = {x, y}
    end

    local astar = ROT.Path.AStar(self.x, self.y, passableCallback)
    astar:compute(target.x, target.y, astarCallback)

    -- If path was found and path is shorter than 25 steps.
    if #path > 0 and #path < 25 then
        -- Move to first tile in A* path.
        self.x = path[#path - 1][1]
        self.y = path[#path - 1][2]
    else
        -- Keep old move function as a backup so that if there are no paths,
        -- f.ex. if another monster blocks corridor, it will still try to move
        -- towards the player.
        self:moveTowards(target.x, target.y, gameMap, entities)
    end

    path = nil
end

function Entity:distance(x, y)
    return math.sqrt(math.pow(self.x - x, 2) + math.pow(self.y - y, 2))
end