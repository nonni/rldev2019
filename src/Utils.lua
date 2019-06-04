
function randInt(min, max)
    return math.random(min, max)
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function wrap(str, limit)
    local lines = {}
    local lineStart = 1

    if #str > limit + lineStart then
        local currentStr = string.sub(str, lineStart, limit)
        while #currentStr == limit do
            table.insert(lines, currentStr)
            lineStart = lineStart + limit
            currentStr = string.sub(str, lineStart, lineStart + limit - 1)
        end
        table.insert(lines, currentStr)
    else
        table.insert(lines, str)
    end

    return lines
end