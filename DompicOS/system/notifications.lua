-- Dompic OS Notification System

local function show(title, text)

    local w, h = term.getSize()

    -- Spara skärmen
    local oldX, oldY = term.getCursorPos()

    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)

    term.setCursorPos(2,1)
    write("                    ")

    term.setCursorPos(2,1)
    print(title)

    term.setCursorPos(2,2)
    print(text)

    sleep(3)

    -- Rensa notisen
    term.setBackgroundColor(colors.white)
    term.clearLine()

    term.setCursorPos(oldX, oldY)
end

return show