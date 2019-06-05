Inventory = Object:extend()

function Inventory:new(capacity)
    self.capacity = capacity
    self.items = {}
end

function Inventory:addItem(item)
    local results = {}

    if #self.items >= self.capacity then
        results[#results+1] = {
            'message',
            Message('You cannot carry any more, your inventory is full', 'yellow')
        }
    else
        results[#results+1] = {
            'itemAdded',
            item,
        }
        results[#results+1] = {
            'message',
            Message(string.format('You pick up the %s', item.name), 'blue')
        }
        table.insert(self.items, item)
    end
    return results
end