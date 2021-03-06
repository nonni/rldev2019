DeathFunctions = {}

function DeathFunctions.killPlayer(player)
    player.char = '%'
    player.color = 'dark red'

    return {Message('You died!', 'red'), Enums.States.PLAYER_DEAD}
end

function DeathFunctions.killMonster(monster)
    local deathMessage = string.format('%s is dead!', string.upper(monster.name))

    monster.char = '%'
    monster.color = 'dark red'
    monster.blocks = false
    monster.fighter = nil
    monster.ai = nil
    monster.name = string.format('remains of %s', monster.name)
    monster.renderOrder = Enums.RenderOrder.CORPSE

    return Message(deathMessage, 'orange')
end

return DeathFunctions