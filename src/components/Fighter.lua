Fighter = Object:extend()

function Fighter:new(hp, defense, power, xp)
    self.maxHp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
    self.xp = xp or 0
end

function Fighter:takeDamage(amount)
    local results = {}
    self.hp = self.hp - amount

    if self.hp <= 0 then
        results[#results+1] = {'dead', self.owner}
        results[#results+1] = {'xp', self.xp}
    end

    return results
end

function Fighter:heal(amount)
    self.hp = math.min(self.hp + amount, self.maxHp)
end

function Fighter:attack(target)
    local results = {}
    local damage = self.power - target.fighter.defense

    if damage > 0 then
        results[#results+1] = {
            'message',
            Message(
                string.format('%s attacks %s for %d hit points', string.upper(self.owner.name), target.name, damage),
                'white')
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
            Message(
                string.format('%s attacks %s but does no damage.', string.upper(self.owner.name), target.name),
                'white')
        }
    end

    return results
end