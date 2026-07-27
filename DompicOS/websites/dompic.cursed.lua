-- Dompic Cursed Website
-- websites/dompic.cursed.lua

local w, h = term.getSize()

term.setBackgroundColor(colors.red)
term.setTextColor(colors.black)
term.clear()


local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end


center("You should not be here...", math.floor(h / 2) - 3)

center("LEAVE... NOW!!!", math.floor(h / 2) - 1)


center("YOU SHOULD NOT KNOW", math.floor(h / 2) + 3)
center("ANYTHING ABOUT THIS!!!", math.floor(h / 2) + 4)


while true do
    os.pullEvent()
end