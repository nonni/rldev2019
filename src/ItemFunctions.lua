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
            local distance = caster:distanceTo(e)
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

function ItemFunctions.castFireball(opts)
    local entities = opts['entities']
    local fovMap = opts['fov_map']
    local damage = opts['damage']
    local radius = opts['radius']
    local targetX = opts['target_x']
    local targetY = opts['target_y']

    local results = {}

    if not fovMap[targetX..','..targetY] then
        table.insert(results, {'consumed', false})
        table.insert(results, {'message', Message('You cannot target a tile outside your field of view.', 'yellow')})
        return results
    end

    table.insert(results, {'consumed', true})
    table.insert(results, {'message', Message(string.format('The fireball explodes, burning everything within %s tiles!', radius), 'orange')})

    for _,e in ipairs(entities) do
        if e.fighter and e:distance(targetX, targetY) <= radius then
            table.insert(results, {'message', Message(string.format('The %s gets burned for %s hit points.', e.name, damage), 'orange')})
            local res = e.fighter:takeDamage(damage)
            for _,r in ipairs(res) do
                table.insert(results, r)
            end
        end
    end

    return results
end

function ItemFunctions.castConfuse(opts)
    local entities = opts['entities']
    local fovMap = opts['fov_map']
    local targetX = opts['target_x']
    local targetY = opts['target_y']

    local results = {}

    if not fovMap[targetX..','..targetY] then
        table.insert(results, {'consumed', false})
        table.insert(results, {'message', Message('You cannot target a tile outside your field of view.', 'yellow')})
        return results
    end

    local foundMonster = false
    for _,e in ipairs(entities) do
        if e.x == targetX and e.y == targetY and e.ai then
            local confusedAI = ConfusedMonster(e.ai, 10)
            confusedAI.owner = e
            e.ai = confusedAI

            table.insert(results, {'consumed', true})
            table.insert(results, {'message', Message(string.format('The eyes of the %s look vacant, as he starts to stumble around!', e.name), 'light green')})

            foundMonster = true
            break
        end
    end

    if not foundMonster then
        table.insert(results, {'consumed', false})
        table.insert(results, {'message', Message('There is no targetable enemy at that location.', 'yellow')})
    end

    return results
end

return ItemFunctions