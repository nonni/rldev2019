ItemFunctions = {}

function ItemFunctions.heal(opts)
    local entity = opts['entity']
    local amount = opts['amount']
    local results = {}

    if entity.fighter.hp == entity.fighter.maxHp then
        table.insert(results, {'consumed', false})
        table.insert(results, {'message', Message('You are already at full health', 'yellow')})
    else
        entity.fighter:heal(amount)
        table.insert(results, {'consumed', true})
        table.insert(results, {'message', Message('Your wounds start to feel better!', 'green')})
    end

    return results
end

return ItemFunctions