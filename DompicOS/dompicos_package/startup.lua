-- DompicOS Startup

local w, h = term.getSize()
local nativeTerm = term.native()

local function getDisplay()
    if not fs.exists("system/display.cfg") then
        return nil
    end

    local f = fs.open("system/display.cfg", "r")
    if not f then
        return nil
    end

    local side = f.readAll()
    f.close()

    if side == "" then
        return nil
    end

    if peripheral.isPresent(side) then
        if peripheral.getType(side) == "monitor" then
            local monitor = peripheral.wrap(side)

            if monitor and type(monitor.getSize) == "function" then
                return monitor
            end
        end
    end

    return nil
end

local display = nil
local displaySide = nil

local function refreshDisplay()
    local newDisplay = getDisplay()

    if newDisplay then
        local newSide = peripheral.getName(newDisplay)

        if display == nil or newSide ~= displaySide then
            display = newDisplay
            displaySide = newSide

            pcall(function()
                display.setTextScale(0.5)
            end)
        end
    else
        display = nil
        displaySide = nil
    end
end

refreshDisplay()

local screenWidth, screenHeight = nativeTerm.getSize()
local screenText = {}
local screenFg = {}
local screenBg = {}

local currentTextColor = colors.white
local currentBackgroundColor = colors.black

local function colorChar(color)
    local map = {
        [colors.white] = "0",
        [colors.orange] = "1",
        [colors.magenta] = "2",
        [colors.lightBlue] = "3",
        [colors.yellow] = "4",
        [colors.lime] = "5",
        [colors.pink] = "6",
        [colors.gray] = "7",
        [colors.lightGray] = "8",
        [colors.cyan] = "9",
        [colors.purple] = "a",
        [colors.blue] = "b",
        [colors.brown] = "c",
        [colors.green] = "d",
        [colors.red] = "e",
        [colors.black] = "f"
    }

    return map[color] or "0"
end

local function newRow()
    local text = {}
    local fg = {}
    local bg = {}

    for x = 1, screenWidth do
        text[x] = " "
        fg[x] = colorChar(currentTextColor)
        bg[x] = colorChar(currentBackgroundColor)
    end

    return text, fg, bg
end

local function resetBuffer()
    for y = 1, screenHeight do
        screenText[y], screenFg[y], screenBg[y] = newRow()
    end
end

resetBuffer()

local function redrawDisplay()
    refreshDisplay()

    if not display then
        return
    end

    if type(display.getSize) ~= "function" then
        display = nil
        displaySide = nil
        return
    end

    local dw, dh = display.getSize()

    -- Keep the computer's screen proportions on the monitor.
    -- The monitor may have a different number of character cells,
    -- so we fit the computer screen inside it instead of simply
    -- copying x/y coordinates.
    local sourceRatio = screenWidth / screenHeight
    local displayRatio = dw / dh

    local viewWidth
    local viewHeight

    if displayRatio > sourceRatio then
        -- Monitor is wider than the computer screen.
        viewHeight = dh
        viewWidth = math.floor(viewHeight * sourceRatio + 0.5)
    else
        -- Monitor is taller/narrower than the computer screen.
        viewWidth = dw
        viewHeight = math.floor(viewWidth / sourceRatio + 0.5)
    end

    if viewWidth < 1 then
        viewWidth = 1
    end

    if viewHeight < 1 then
        viewHeight = 1
    end

    local offsetX = math.floor((dw - viewWidth) / 2)
    local offsetY = math.floor((dh - viewHeight) / 2)

    display.clear()

    -- Draw the screen with proportional coordinate mapping.
    -- This keeps the desktop layout in the same relative positions.
    for dy = 1, viewHeight do

        local sourceY = math.floor(
            ((dy - 1) * screenHeight) / viewHeight
        ) + 1

        if sourceY > screenHeight then
            sourceY = screenHeight
        end

        local text = ""
        local fg = ""
        local bg = ""

        for dx = 1, viewWidth do

            local sourceX = math.floor(
                ((dx - 1) * screenWidth) / viewWidth
            ) + 1

            if sourceX > screenWidth then
                sourceX = screenWidth
            end

            text = text .. screenText[sourceY][sourceX]
            fg = fg .. screenFg[sourceY][sourceX]
            bg = bg .. screenBg[sourceY][sourceX]
        end

        display.setCursorPos(
            offsetX + 1,
            offsetY + dy
        )

        display.blit(text, fg, bg)
    end

    -- Put the monitor cursor in the same relative position.
    local cx, cy = nativeTerm.getCursorPos()

    local displayX = offsetX + math.floor(
        ((cx - 1) * viewWidth) / screenWidth
    ) + 1

    local displayY = offsetY + math.floor(
        ((cy - 1) * viewHeight) / screenHeight
    ) + 1

    if displayX >= 1 and displayX <= dw
    and displayY >= 1 and displayY <= dh then
        display.setCursorPos(displayX, displayY)
    end
end

local function bufferWrite(text, fg, bg)
    local x, y = nativeTerm.getCursorPos()

    for i = 1, #text do
        if x >= 1 and x <= screenWidth and y >= 1 and y <= screenHeight then
            screenText[y][x] = string.sub(text, i, i)

            if fg then
                screenFg[y][x] = string.sub(fg, i, i)
            else
                screenFg[y][x] = colorChar(currentTextColor)
            end

            if bg then
                screenBg[y][x] = string.sub(bg, i, i)
            else
                screenBg[y][x] = colorChar(currentBackgroundColor)
            end
        end

        x = x + 1

        if x > screenWidth then
            x = 1
            y = y + 1
        end
    end
end

local mirror = {}

function mirror.write(text)
    nativeTerm.write(text)
    bufferWrite(text)
    redrawDisplay()
end

function mirror.blit(text, fg, bg)
    nativeTerm.blit(text, fg, bg)
    bufferWrite(text, fg, bg)
    redrawDisplay()
end

function mirror.clear()
    nativeTerm.clear()
    resetBuffer()
    redrawDisplay()
end

function mirror.clearLine()
    local _, y = nativeTerm.getCursorPos()
    nativeTerm.clearLine()

    if y >= 1 and y <= screenHeight then
        for x = 1, screenWidth do
            screenText[y][x] = " "
            screenFg[y][x] = colorChar(currentTextColor)
            screenBg[y][x] = colorChar(currentBackgroundColor)
        end
    end

    redrawDisplay()
end

function mirror.scroll(lines)
    nativeTerm.scroll(lines)

    if lines > 0 then
        if lines > screenHeight then
            lines = screenHeight
        end

        for y = 1, screenHeight - lines do
            screenText[y] = screenText[y + lines]
            screenFg[y] = screenFg[y + lines]
            screenBg[y] = screenBg[y + lines]
        end

        for y = screenHeight - lines + 1, screenHeight do
            screenText[y], screenFg[y], screenBg[y] = newRow()
        end
    elseif lines < 0 then
        lines = -lines

        if lines > screenHeight then
            lines = screenHeight
        end

        for y = screenHeight, lines + 1, -1 do
            screenText[y] = screenText[y - lines]
            screenFg[y] = screenFg[y - lines]
            screenBg[y] = screenBg[y - lines]
        end

        for y = 1, lines do
            screenText[y], screenFg[y], screenBg[y] = newRow()
        end
    end

    redrawDisplay()
end

function mirror.setCursorPos(x, y)
    nativeTerm.setCursorPos(x, y)
    redrawDisplay()
end

function mirror.getCursorPos()
    return nativeTerm.getCursorPos()
end

function mirror.setCursorBlink(value)
    nativeTerm.setCursorBlink(value)

    if display then
        pcall(function()
            display.setCursorBlink(value)
        end)
    end
end

function mirror.getCursorBlink()
    return nativeTerm.getCursorBlink()
end

function mirror.setTextColor(color)
    currentTextColor = color
    nativeTerm.setTextColor(color)

    if display then
        pcall(function()
            display.setTextColor(color)
        end)
    end
end

mirror.setTextColour = mirror.setTextColor

function mirror.getTextColor()
    return nativeTerm.getTextColor()
end

mirror.getTextColour = mirror.getTextColor

function mirror.setBackgroundColor(color)
    currentBackgroundColor = color
    nativeTerm.setBackgroundColor(color)

    if display then
        pcall(function()
            display.setBackgroundColor(color)
        end)
    end
end

mirror.setBackgroundColour = mirror.setBackgroundColor

function mirror.getBackgroundColor()
    return nativeTerm.getBackgroundColor()
end

mirror.getBackgroundColour = mirror.getBackgroundColor

function mirror.getSize()
    return nativeTerm.getSize()
end

function mirror.isColor()
    return nativeTerm.isColor()
end

mirror.isColour = mirror.isColor

function mirror.setPaletteColor(color, r, g, b)
    nativeTerm.setPaletteColor(color, r, g, b)

    if display then
        pcall(function()
            display.setPaletteColor(color, r, g, b)
        end)
    end
end

mirror.setPaletteColour = mirror.setPaletteColor

function mirror.getPaletteColor(color)
    return nativeTerm.getPaletteColor(color)
end

mirror.getPaletteColour = mirror.getPaletteColor

function mirror.native()
    return nativeTerm
end

term.redirect(mirror)

if fs.exists("system/boot_animation.lua") then
    shell.run("system/boot_animation.lua")
end

local settings = dofile("system/settings.lua")
local appSize = tonumber(settings.appSize) or 1

local menuOpen = false
local apps = {}

if not fs.exists("apps") then
    fs.makeDir("apps")
end

for _, file in ipairs(fs.list("apps")) do
    if file:match("%.lua$")
    and file ~= "explorer.lua"
    and file ~= "settings.lua"
    and file ~= "system.lua" then
        table.insert(apps, file)
    end
end

local appPositions = {}

local function getAppName(file)
    local name = file:gsub("%.lua",""):gsub("_"," ")

    if name == "dompic kommun service" then
        name = "Dompic Service"
    elseif name == "dompic delivery" then
        name = "Dompic Delivery"
    elseif name == "browser" then
        name = "Dompic Browser"
    elseif name == "system" then
        name = "Settings"
    end

    return name
end

local function drawDesktop()
    appPositions = {}

    local bg = settings.background

    if bg == "bright_orange" then
        term.setBackgroundColor(colors.orange)
    else
        term.setBackgroundColor(colors[bg] or colors.blue)
    end

    term.clear()

    local sw, sh = term.getSize()

    term.setBackgroundColor(colors.gray)

    paintutils.drawFilledBox(
        1,
        sh,
        sw,
        sh
    )

    term.setBackgroundColor(colors.orange)

    paintutils.drawFilledBox(
        1,
        sh,
        5,
        sh
    )

    term.setTextColor(colors.white)
    term.setCursorPos(3, sh)
    write(">")

    term.setBackgroundColor(colors.lightGray)

    paintutils.drawFilledBox(
        10,
        sh,
        12,
        sh
    )

    term.setBackgroundColor(colors.yellow)

    paintutils.drawFilledBox(
        15,
        sh,
        17,
        sh
    )

    local x = 3
    local y = 3
    local count = 0

    local boxWidth = math.max(
        3,
        math.floor(7 * appSize)
    )

    local boxHeight = math.max(
        2,
        math.floor(3 * appSize)
    )

    for _, app in ipairs(apps) do
        local name = getAppName(app)

        term.setBackgroundColor(colors.orange)

        paintutils.drawFilledBox(
            x,
            y,
            x + boxWidth,
            y + boxHeight
        )

        term.setTextColor(colors.white)

        term.setCursorPos(
            x + 1,
            y + 1
        )

        write(
            string.sub(
                name,
                1,
                boxWidth - 1
            )
        )

        table.insert(
            appPositions,
            {
                name = app,
                x = x,
                y = y,
                width = boxWidth,
                height = boxHeight
            }
        )

        count = count + 1

        if count >= 4 then
            count = 0
            x = 3
            y = y + boxHeight + 2
        else
            x = x + boxWidth + 4
        end
    end

    redrawDisplay()
end

local function drawMenu()
    term.setBackgroundColor(colors.orange)

    paintutils.drawFilledBox(
        1,
        h - 9,
        22,
        h - 1
    )

    term.setTextColor(colors.white)

    term.setCursorPos(3, h - 8)
    write("DompicOS")

    term.setCursorPos(3, h - 7)
    write("Version 1.1.6")

    term.setCursorPos(3, h - 5)
    write("----------------")

    term.setCursorPos(3, h - 3)
    write("Reset")

    term.setCursorPos(3, h - 2)
    write("Shutdown")

    redrawDisplay()
end

drawDesktop()

while true do
    local event, button, x, y = os.pullEvent()

    if event == "peripheral" or event == "peripheral_detach" then
        redrawDisplay()

    elseif event == "mouse_click" then

        if x >= 10 and x <= 12 and y == h then
            shell.run("apps/settings.lua")
            drawDesktop()
        end

        if x >= 15 and x <= 17 and y == h then
            shell.run("apps/explorer.lua")
            drawDesktop()
        end

        if x <= 5 and y == h then
            menuOpen = true
            drawMenu()
        end

        if menuOpen then
            if y == h - 5 then
                os.reboot()
            elseif y == h - 3 then
                os.shutdown()
            end
        end

        for _, app in ipairs(appPositions) do
            if x >= app.x
            and x <= app.x + app.width
            and y >= app.y
            and y <= app.y + app.height then
                shell.run("apps/" .. app.name)
                drawDesktop()
            end
        end

    elseif event == "key" then
        if button == keys.v then
            os.reboot()
        end
    end
end
