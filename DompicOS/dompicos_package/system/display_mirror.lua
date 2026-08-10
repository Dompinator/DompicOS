local displayFile = "system/display.cfg"

local native = term.native()

local mirror = {}

local function getMonitor()
    if not fs.exists(displayFile) then
        return nil
    end

    local f = fs.open(displayFile, "r")
    if not f then
        return nil
    end

    local side = f.readAll()
    f.close()

    if not side or side == "" then
        return nil
    end

    if not peripheral.isPresent(side) then
        return nil
    end

    if peripheral.getType(side) ~= "monitor" then
        return nil
    end

    return peripheral.wrap(side)
end

local function both(method, ...)
    local args = {...}

    local result = {native[method](table.unpack(args))}

    local mon = getMonitor()

    if mon then
        pcall(function()
            mon[method](table.unpack(args))
        end)
    end

    return table.unpack(result)
end

function mirror.write(text)
    both("write", text)
end

function mirror.blit(text, fg, bg)
    both("blit", text, fg, bg)
end

function mirror.clear()
    both("clear")
end

function mirror.clearLine()
    both("clearLine")
end

function mirror.setCursorPos(x, y)
    both("setCursorPos", x, y)
end

function mirror.setCursorBlink(value)
    both("setCursorBlink", value)
end

function mirror.setTextColor(color)
    both("setTextColor", color)
end

function mirror.setTextColour(color)
    both("setTextColour", color)
end

function mirror.setBackgroundColor(color)
    both("setBackgroundColor", color)
end

function mirror.setBackgroundColour(color)
    both("setBackgroundColour", color)
end

function mirror.scroll(lines)
    both("scroll", lines)
end

function mirror.setPaletteColor(...)
    both("setPaletteColor", ...)
end

function mirror.setPaletteColour(...)
    both("setPaletteColour", ...)
end

function mirror.getCursorPos()
    return native.getCursorPos()
end

function mirror.getCursorBlink()
    return native.getCursorBlink()
end

function mirror.getTextColor()
    return native.getTextColor()
end

function mirror.getTextColour()
    return native.getTextColor()
end

function mirror.getBackgroundColor()
    return native.getBackgroundColor()
end

function mirror.getBackgroundColour()
    return native.getBackgroundColor()
end

function mirror.getSize()
    return native.getSize()
end

function mirror.isColor()
    return native.isColor()
end

function mirror.isColour()
    return native.isColour()
end

function mirror.getPaletteColor(...)
    return native.getPaletteColor(...)
end

function mirror.getPaletteColour(...)
    return native.getPaletteColor(...)
end

function mirror.setCursorPos(...)
    local x, y = ...
    native.setCursorPos(x, y)

    local mon = getMonitor()
    if mon then
        pcall(mon.setCursorPos, mon, x, y)
    end
end

return mirror