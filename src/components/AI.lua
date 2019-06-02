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