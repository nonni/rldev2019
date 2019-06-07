
InputHandler = {}

InputHandler.keyActions = {
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
    [terminal.TK_RETURN] = function() return terminal.check(terminal.TK_CONTROL) and {'fullscreen', true} or {} end
}

function InputHandler.handleKeys(key)
    local action = InputHandler.keyActions[key]
    return action and type(action) == "function" and action() or action
end

return InputHandler