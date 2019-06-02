DeathFunctions = {}

function DeathFunctions.killPlayer(player)
    player.char = '%'
    player.color = 'dark red'

    return {'You died!', Game.STATES.PLAYER_DEAD}
end

function DeathFunctions.killMonster(monster)
    local deathMessage = string.format('%s is dead!', string.upper(monster.name))

    monster.char = '%'
    monster.color = 'dark red'
    monster.blocks = false
    monster.fighter = nil
    monster.ai = nil
    monster.name = string.format('remains of %s', monster.name)

    return deathMessage
end

return DeathFunctions