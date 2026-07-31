-- Dompic Cursed Home
-- websites/dompic.cursed.home.lua

local w, h = term.getSize()

local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end


local function draw()

    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.black)
    term.clear()


    center("CURSED Dompic Browser", math.floor(h / 2) - 3)


    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)

    local search = "[                    ]"

    term.setCursorPos(math.floor((w - #search) / 2) + 1, math.floor(h / 2))
    write(search)

end



draw()


while true do

    local event, button, x, y = os.pullEvent("mouse_click")


    local search = "[                    ]"
    local searchX = math.floor((w - #search) / 2) + 1
    local searchY = math.floor(h / 2)


    if y == searchY and x >= searchX and x <= searchX + #search then


        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)

        term.setCursorPos(searchX + 1, searchY)

        local address = read()


        if address ~= "" then

            -- Hidden Cursed website
            if address == "Dompic.Cursed" then

                shell.run("websites/dompic.cursed.lua", "cursed_home")


            else

                shell.run("websites/" .. address .. ".lua")

            end

        end

        draw()

    end

end