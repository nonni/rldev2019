Menus = {}

function Menus.menu(layer, header, options, width, screenWidth, screenHeight)
    if #options > 26 then 
        error('Cannot have a menu with more than 26 options.')
    end

    -- calculate total height for the header (after auto-wrap) and one line per option
    -- TODO: better calculation
    local headerHeight = math.floor(#header / screenWidth) + 1
    local height = #options + headerHeight

    -- Get starting x and y coordinates of menu.
    local startX = math.floor((screenWidth / 2) - (width / 2))
    local currentY = math.floor((screenHeight / 2) - (height / 2))

    local headerLines = wrap(header, width)
    local totalHeight = #headerLines + #options

    RenderFunctions.rectangle(Enums.Layers.UI_BACK, 'gray', startX, currentY, width, totalHeight)
    terminal.layer(layer)
    -- Print header
    for _,v in ipairs(headerLines) do
        terminal.print(startX, currentY, ''..v)
        currentY = currentY + 1
    end

    currentY = currentY + 1

    local currentChar = string.byte('a')
    -- Print all the options
    for _,option in ipairs(options) do
        terminal.print(startX, currentY, string.format('(%s) %s', string.char(currentChar), option))
        currentY = currentY + 1
        currentChar = currentChar + 1
    end
end

function Menus.inventoryMenu(layer, header, inventory, inventoryWidth, screenWidth, screenHeight)
    -- Show a menu with each item of the inventory as an option
    local options
    if #inventory.items == 0 then
        options = {'Inventory is empty'}
    else
        options = {}
        for _,v in ipairs(inventory.items) do
            table.insert(options, v.name)
        end
    end

    Menus.menu(layer, header, options, inventoryWidth, screenWidth, screenHeight)
end