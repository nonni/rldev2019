Entity = Object:extend()

function Entity:new(x, y, char, color, opts)
    local iopts = opts or {}
    if iopts then for k, v in pairs(iopts) do self[k] = v end end

    self.x, self.y = x, y
    self.char = char
    self.color = color

end

function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end
