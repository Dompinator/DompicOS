-- Dompic OS Notification System

local title = arg[1] or "Dompic OS"
local message = arg[2] or ""

local w, h = term.getSize()

-- Rita notis
term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)

term.setCursorPos(2,1)

for i = 1, w - 2 do
    write(" ")
end

term.setCursorPos(3,1)
write(title)

term.setCursorPos(3,2)
write(message)


-- Visa i 6 sekunder
sleep(6)


-- Ta bort notis
term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)

term.setCursorPos(2,1)

for i = 1, w - 2 do
    write(" ")
end

term.setCursorPos(1,1)