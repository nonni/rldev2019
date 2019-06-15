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

function ItemFunctions.castLightning(opts)
    local caster = opts['entity']
    local entities = opts['entities']
    local fovMap = opts['fov_map']
    local damage = opts['damage']
    local maximumRange = opts['maximum_range']

    local results = {}

    local target
    local closestDistance = maximumRange + 1

    for _,e in ipairs(entities) do
        if e.fighter and
            e.id ~= caster.id and
            fovMap[e.x..','..e.y]
        then
            local distance = caster:distance(e)
            if distance < closestDistance then
                target = e
                closestDistance = distance
            end
        end
    end

    if target then
        table.insert(results, {'consumed', true})
        table.insert(results, {'target', target})
        table.insert(results, {'message', Message(string.format('A lighting bolt strikes the %s with a loud thunder! The damage is %s', target.name, damage))})
        local res = target.fighter:takeDamage(damage)
        for _,v in ipairs(res) do
            table.insert(results, v)
        end
    else
        table.insert(results, {'consumed', false})
        table.insert(results, {'target', nil})
        table.insert(results, {'message', Message('No enemy is close enough to strike.', 'red')})
    end

    return results
end

return ItemFunctions