-- Dompic Delivery
-- apps/delivery.lua

local w, h = term.getSize()

local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

local function button(text, y)
    local x = math.floor((w - #text - 4) / 2)
    term.setCursorPos(x, y)
    print("[ " .. text .. " ]")
    return x, y, #text + 4
end

local function clearScreen()
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.clear()
end

local page = "main"

while true do
    clearScreen()

    if page == "main" then
        center("DOMPIC DELIVERY", 3)
        center("----------------", 4)
        center("Choose delivery:", 6)

        local bx, by, bw = button("Extra Cookies", 8)

        local event, side, x, y = os.pullEvent("mouse_click")

        if y == by and x >= bx and x <= bx + bw then
            page = "cookies"
        end


    elseif page == "cookies" then
        center("EXTRA COOKIES", 3)
        center("----------------", 4)

        center("16 Fresh Cookies", 6)
        center("Price: 4 Gold Coins", 7)

        local bx, by, bw = button("Buy 16 Cookies", 9)

        local event, side, x, y = os.pullEvent("mouse_click")

        if y == by and x >= bx and x <= bx + bw then
            
            clearScreen()

            -- Kolla om spelaren har minst 4 coins
            local check = commands.exec(
                "execute if entity @p[nbt={Inventory:[{id:\"moneyforeveryone:coin_gold\",Count:4b}]}] run say HAS_COINS"
            )

            if check then

                -- Ta 4 coins
                commands.exec(
                    "clear @p moneyforeveryone:coin_gold 4"
                )

                -- Ge kakor
                commands.exec(
                    "give @p minecraft:cookie 16"
                )

                center("Delivery complete!", 5)
                center("+16 Cookies", 7)

            else

                center("Purchase failed!", 5)
                center("Need 4 Gold Coins", 7)

            end

            sleep(3)
            page = "main"
        end
    end
end