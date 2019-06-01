Entity = Object:extend()

function Entity:new(x, y, char, color, name, blocks, opts)
    local iopts = opts or {}
    if iopts then for k, v in pairs(iopts) do self[k] = v end end

    self.x, self.y = x, y
    self.char = char
    self.color = color
    self.name = name
    self.blocks = blocks or false

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