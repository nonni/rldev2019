
InputHandler = {}

InputHandler.playerTurnKeyActions = {
    [terminal.TK_ESCAPE] = {'exit', true},
    [terminal.TK_CLOSE] = {'exit', true},
    [terminal.TK_UP] = {'move', {0, -1}},
    [terminal.TK_DOWN] = {'move', {0, 1}},
    [terminal.TK_LEFT] = {'move', {-1, 0}},
    [terminal.TK_RIGHT] = {'move', {1, 0}},
    [terminal.TK_K] = {'move', {0, -1}},
    [terminal.TK_J] = {'move', {0, 1}},
    [terminal.TK_H] = {'move', {-1, 0}},
    [terminal.TK_L] = {'move', {1, 0}},
    [terminal.TK_Y] = {'move', {-1, -1}},
    [terminal.TK_U] = {'move', {1, -1}},
    [terminal.TK_B] = {'move', {-1, 1}},
    [terminal.TK_N] = {'move', {1, 1}},
    [terminal.TK_G] = {'pickup', true},
    [terminal.TK_I] = {'show_inventory', true},
    [terminal.TK_D] = {'drop_inventory', true},
    [terminal.TK_RETURN] = function() return terminal.check(terminal.TK_CONTROL) and {'fullscreen', true} or {} end
}

InputHandler.playerDeadKeyActions = {
    [terminal.TK_I] = {'show_inventory', true},
    [terminal.TK_ESCAPE] = {'exit', true},
    [terminal.TK_RETURN] = function() return terminal.check(terminal.TK_CONTROL) and {'fullscreen', true} or {} end
}

function InputHandler.inventoryKeyActions(key)
    if key == terminal.TK_ESCAPE then
        return {'exit', true}
    elseif key == terminal.TK_RETURN and terminal.check(terminal.TK_CONTROL) then
        return {'fullscreen', true}
    elseif terminal.check(terminal.TK_CHAR) then
        local index = math.floor(terminal.state(terminal.TK_CHAR) - string.byte('a') + 1)
        if index >= 0 then
            return {'inventory_index', index}
        end
    end

    return {}
end

function InputHandler.handleKeys(key, gameState)
    local actions
    if gameState == Enums.States.PLAYERS_TURN then
        actions = InputHandler.playerTurnKeyActions
    elseif gameState == Enums.States.PLAYER_DEAD then
        actions = InputHandler.playerDeadKeyActions
    elseif gameState == Enums.States.SHOW_INVENTORY or
        gameState == Enums.States.DROP_INVENTORY then
        return InputHandler.inventoryKeyActions(key)
    end

    if actions then
        local action = actions[key]
        return action and type(action) == "function" and action() or action
    else
        print ('return empty')
        return {}
    end
end


return InputHandler