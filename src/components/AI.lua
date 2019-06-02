BasicMonster = Object:extend()

function BasicMonster:takeTurn(target, fovMap, gameMap, entities)
    local monster = self.owner
    if fovMap[monster.x..','..monster.y] then
        if monster:distanceTo(target) >= 2 then
            monster:moveTowards(target.x, target.y, gameMap, entities)
        elseif target.fighter.hp > 0 then
            print ('The ' .. monster.name .. ' insults you! Your ego is damaged')
        end
    end
end