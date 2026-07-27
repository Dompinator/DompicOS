-- Dompic Kommun Service

local w, h = term.getSize()


local function drawMain()

    term.setBackgroundColor(colors.white)
    term.clear()

    term.setBackgroundColor(colors.blue)
    paintutils.drawFilledBox(1, 1, w, 3)

    term.setTextColor(colors.white)
    term.setCursorPos(3, 2)
    term.write("Dompic Kommun Service")


    paintutils.drawFilledBox(3, 6, 25, 8)
    paintutils.drawFilledBox(3, 10, 25, 12)

    term.setTextColor(colors.white)

    term.setCursorPos(5, 7)
    term.write("Government Log-In")

    term.setCursorPos(5, 11)
    term.write("DompicCity Map")
end



local function citizens()

    term.setBackgroundColor(colors.white)
    term.clear()

    term.setTextColor(colors.blue)
    term.setCursorPos(3, 3)
    term.write("DompicCity Medborgare")

    term.setTextColor(colors.black)

    term.setCursorPos(3, 5)
    term.write("Registrerade medborgare:")


    term.setCursorPos(3, 7)
    term.write("Dompinat0r - Mayor, Epicvoid69V - Citizen")


    term.setCursorPos(3, h-1)
    term.write("Press any key to return")

    os.pullEvent("key")

end



local function adminPanel()

    term.setBackgroundColor(colors.white)
    term.clear()

    term.setTextColor(colors.orange)

    term.setCursorPos(3, 3)
    term.write("Dompic Administrator")


    term.setTextColor(colors.black)

    term.setCursorPos(3, 5)
    term.write("Welcome back, Dompinat0r!")


    paintutils.drawFilledBox(3, 8, 25, 10)

    term.setTextColor(colors.white)
    term.setCursorPos(5, 9)
    term.write("Medborgare")


    while true do

        local event, button, x, y = os.pullEvent()


        if event == "mouse_click" then

            if x >= 3 and x <= 25 and y >= 8 and y <= 10 then

                citizens()

                adminPanel()
                return

            end
        end
    end
end



local function login()

    term.setBackgroundColor(colors.white)
    term.clear()

    term.setTextColor(colors.blue)
    term.setCursorPos(3, 3)
    term.write("Government Log-In")


    term.setTextColor(colors.black)

    term.setCursorPos(3, 6)
    term.write("Username:")

    term.setCursorPos(3, 7)
    local username = read()


    term.setCursorPos(3, 9)
    term.write("Password:")

    term.setCursorPos(3, 10)
    local password = read("*")



    if username == "Dompinat0r" and password == "1379" then

        adminPanel()


    elseif password == "1234" then

        term.setBackgroundColor(colors.white)
        term.clear()

        term.setTextColor(colors.blue)

        term.setCursorPos(3, 5)
        term.write("Welcome " .. username .. "!")

        term.setTextColor(colors.black)

        term.setCursorPos(3, 7)
        term.write("Government access granted.")


        term.setCursorPos(3, h-1)
        term.write("Press any key to return")

        os.pullEvent("key")


    else

        term.setTextColor(colors.red)

        term.setCursorPos(3, 12)
        term.write("Wrong password!")

        sleep(2)

    end

end



drawMain()



while true do

    local event, button, x, y = os.pullEvent()


    if event == "mouse_click" then


        if x >= 3 and x <= 25 and y >= 6 and y <= 8 then

            login()

            drawMain()

        end



        if x >= 3 and x <= 25 and y >= 10 and y <= 12 then

            term.setBackgroundColor(colors.white)
            term.clear()

            term.setTextColor(colors.blue)

            term.setCursorPos(3, 3)
            term.write("DompicCity Map")

            term.setTextColor(colors.black)

            term.setCursorPos(3, 5)
            term.write("Map coming soon...")


            term.setCursorPos(3, h-1)
            term.write("Press any key to return")

            os.pullEvent("key")

            drawMain()

        end

    end

end