Inventory = Object:extend()

function Inventory:new(capacity)
    self.capacity = capacity
    self.items = {}
end