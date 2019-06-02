Entity = Object:extend()

function Entity:new(x, y, char, color, name, blocks, fighter, ai, opts)
    local iopts = opts or {}
    if iopts then for k, v in pairs(iopts) do self[k] = v end end

    self.x, self.y = x, y
    self.char = char
    self.color = color
    self.name = name
    self.blocks = blocks or false
    self.fighter = fighter
    self.ai = ai

    if self.fighter then
        self.fighter.owner = self
    end

    if self.ai then
        self.ai.owner = self
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