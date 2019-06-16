BasicMonster = Object:extend()

function BasicMonster:takeTurn(target, fovMap, gameMap, entities)
    local results = {}
    local monster = self.owner
    if fovMap[monster.x..','..monster.y] then
        if monster:distanceTo(target) >= 2 then
            --monster:moveTowards(target.x, target.y, gameMap, entities)
            monster:moveAStar(target, gameMap, entities)
        elseif target.fighter.hp > 0 then
            local attackResults = monster.fighter:attack(target)
            if attackResults then
                for _,v in ipairs(attackResults) do
                    results[#results+1] = v
                end
            end
        end
    end

    return results
end

ConfusedMonster = Object:extend()

function ConfusedMonster:new(previousAI, numberOfTurns)
    self.numberOfTurns = numberOfTurns or 10
    self.previousAI = previousAI
end

function ConfusedMonster:takeTurn(_, _, gameMap, entities)
    local results = {}

    if self.numberOfTurns > 0 then
        local randomX = self.owner.x + randInt(0, 2) - 1
        local randomY = self.owner.y + randInt(0, 2) - 1

        if randomX ~= self.owner.x and randomY ~= self.owner.y then
            self.owner:moveTowards(randomX, randomY, gameMap, entities)
        end

        self.numberOfTurns = self.numberOfTurns - 1
    else
        self.owner.ai = self.previousAI
        table.insert(results, {'message', Message(string.format('The %s is no longer confused!', self.owner.name), 'red')})
    end

    return results
end