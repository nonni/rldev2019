Fighter = Object:extend()

function Fighter:new(hp, defense, power)
    self.maxHp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end

function Fighter:takeDamage(amount)
    local results = {}
    self.hp = self.hp - amount

    if self.hp <= 0 then
        results[#results+1] = {'dead', self.owner}
    end

    return results
end

function Fighter:attack(target)
    local results = {}
    local damage = self.power - target.fighter.defense

    if damage > 0 then
        results[#results+1] = {
            'message', 
            string.format('%s attacks %s for %d hit points', string.upper(self.owner.name), target.name, damage)
        }

        local dmgRes = target.fighter:takeDamage(damage)
        if dmgRes then
            -- Add takeDamage results to results.
            for _,v in ipairs(dmgRes) do
                results[#results+1] = v
            end
        end
    else
        results[#results+1] = {
            'message', 
            string.format('%s attacks %s but does no damage.', string.upper(self.owner.name), target.name)
        }
    end

    return results
end