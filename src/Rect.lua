Rect = Object:extend()

function Rect:new(x, y, w, h)
    self.x1 = x
    self.y1 = y
    self.x2 = x + w
    self.y2 = y + h
end

function Rect:center()
    local centerX = math.floor((self.x1 + self.x2) / 2)
    local centerY = math.floor((self.y1 + self.y2) / 2)
    return {x = centerX, y = centerY}
end

function Rect:intersect(other)
    -- Returns true if this rectangle intersects with another one.
    return (self.x1 <= other.x2 and self.x2 >= other.x1 and
            self.y1 <= other.y2 and self.y2 >= other.y1)
end