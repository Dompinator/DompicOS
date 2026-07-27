-- Dompic Home
-- websites/dompic.home.lua

local w, h = term.getSize()


local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    write(text)
end


local function draw()

    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.orange)
    term.clear()


    center("Dompic Browser", math.floor(h / 2) - 3)


    -- Search bar
    local search = "[                    ]"

    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)

    term.setCursorPos(
        math.floor((w - #search) / 2) + 1,
        math.floor(h / 2)
    )

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

            -- Hidden Cursed website protection
            if address == "dompic.cursed" or address == "Dompic.Cursed" then

                term.setBackgroundColor(colors.black)
                term.setTextColor(colors.red)
                term.clear()

                term.setCursorPos(3,5)
                print("ACCESS DENIED")

                term.setCursorPos(3,7)
                print("This website is hidden.")

                sleep(3)

                draw()

            else

                shell.run("websites/" .. address .. ".lua")

                draw()

            end

        end
    end
end