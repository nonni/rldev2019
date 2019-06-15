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

function Inventory:use(entity, opts)
    local results = {}
    local itemComponent = entity.item

    if not itemComponent.useFunction then
        table.insert(results, {'message', Message(string.format('The %s cannot be used', entity.name), 'yellow')})
    else
        local args = itemComponent.defaultOpts
        args.entity = self.owner
        if opts then
            for k,v in pairs(opts) do
                args[k] = v
            end
        end
        local itemUseResult = itemComponent.useFunction(args)
        for _,v in ipairs(itemUseResult) do
            if v[1] == 'consumed' and v[2] == true then
                for i,x in ipairs(self.items) do
                    if x.id == entity.id then
                        table.remove(self.items, i)
                        break
                    end
                end
            end

            table.insert(results, v)
        end
    end

    return results
end

function Inventory:dropItem(entity)
    local results = {}

    entity.x = self.owner.x
    entity.y = self.owner.y

    for i,x in ipairs(self.items) do
        if x.id == entity.id then
            table.remove(self.items, i)
            break
        end
    end

    table.insert(results, {'item_dropped', entity})
    table.insert(results, {'message', Message(string.format('You dropped %s', entity.name), 'yellow')})

    return results
end