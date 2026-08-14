-- websites/dompic.freesugar.lua
-- Free Sugar Store page

local w, h = term.getSize()

local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    write(text)
end

-- Clean white background
term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.clear()

-- Header
term.setTextColor(colors.gray)
center("══════════════════════════════", 2)
term.setTextColor(colors.black)
center("EPICHAMN SUGAR STORE", 3)
term.setTextColor(colors.gray)
center("══════════════════════════════", 4)

-- Main content
term.setTextColor(colors.black)
center("Welcome!", math.floor(h / 2) - 4)
center("You can get free sugar here:", math.floor(h / 2) - 2)

term.setTextColor(colors.blue)
center("Lyxvägen 2", math.floor(h / 2))
center("Epichamn", math.floor(h / 2) + 1)

term.setTextColor(colors.black)
center("Just come by and ask!", math.floor(h / 2) + 3)

-- Footer
term.setTextColor(colors.gray)
center("Press any key to go back", h - 2)

-- Keep the page open
os.pullEvent("key")