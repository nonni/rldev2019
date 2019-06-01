--[[
    A tile on a map. It may or may not be blocked, and may or may not block sight.
]]--
Tile = Object:extend()

function Tile:new(blocked, blockSight)
    self.blocked = blocked

    -- By default, if a tile is blocked, it also blocks sight
    self.blockSight = blockSight or blocked
end