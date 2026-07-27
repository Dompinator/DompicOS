-- DompicOS Settings
-- apps/system.lua

local settings = dofile("system/settings.lua")

local w, h = term.getSize()

local scroll = 0

local selected = settings.background or "dark_blue"
local appSize = tonumber(settings.appSize) or 1

local sliderY = 0


local options = {

    {
        name="Dark Blue",
        id="dark_blue",
        color=colors.blue
    },

    {
        name="Bright Orange",
        id="bright_orange",
        color=colors.orange
    },

    {
        name="Purple",
        id="purple",
        color=colors.purple
    }

}



local function draw()

    term.setBackgroundColor(colors.white)
    term.clear()


    -- Top bar

    term.setBackgroundColor(colors.orange)
    paintutils.drawFilledBox(1,1,w,3)

    term.setTextColor(colors.white)

    term.setCursorPos(3,2)
    write("Dompic Settings")



    -- Sidebar

    term.setBackgroundColor(colors.lightGray)

    paintutils.drawFilledBox(
        1,
        4,
        16,
        h
    )


    term.setTextColor(colors.black)

    term.setCursorPos(3,6)
    write("Appearance")



    local offset = 5 - scroll


    term.setCursorPos(20,offset)
    write("Appearance")



    term.setCursorPos(20,offset+3)
    write("Background")


    term.setCursorPos(20,offset+4)
    write("----------------")



    local y = offset + 6



    for _, option in ipairs(options) do


        if selected == option.id then
            term.setBackgroundColor(colors.lime)
        else
            term.setBackgroundColor(colors.gray)
        end


        term.setCursorPos(20,y)
        write("   ")


        term.setBackgroundColor(option.color)

        term.setCursorPos(21,y)
        write(" ")

        term.setCursorPos(22,y)
        write(" ")



        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)

        term.setCursorPos(25,y)
        write(option.name)


        y = y + 2

    end





    -- App Size

    term.setCursorPos(20,y+1)
    write("App Size")


    term.setCursorPos(20,y+2)
    write("----------------")



    sliderY = y+4



    for i = 1,20 do


        local value = 0.1 + ((i-1)/19)*1.9


        if value <= appSize then
            term.setBackgroundColor(colors.orange)
        else
            term.setBackgroundColor(colors.gray)
        end


        term.setCursorPos(20+i,sliderY)
        write(" ")

    end



    term.setBackgroundColor(colors.white)

    term.setCursorPos(20,sliderY+2)

    write(
        "Size: "..string.format("%.1f",appSize)
    )





    -- Scrollbar

    term.setBackgroundColor(colors.lightGray)

    paintutils.drawFilledBox(
        w,
        4,
        w,
        h-1
    )


    local handleY = 4 + math.floor(
        (scroll/10)*(h-8)
    )


    term.setBackgroundColor(colors.gray)

    paintutils.drawFilledBox(
        w,
        handleY,
        w,
        handleY+2
    )

end





draw()



while true do


    local event, button, x, y = os.pullEvent()



    if event == "mouse_click" then



        local bg = {

            {id="dark_blue", y=11-scroll},

            {id="bright_orange", y=13-scroll},

            {id="purple", y=15-scroll}

        }



        for _, option in ipairs(bg) do


            if x >= 20 and x <= 23 and y == option.y then


                selected = option.id

                settings.background = selected


                if settings.save then
                    settings.save()
                end


                draw()

            end

        end





        if y == sliderY and x >= 21 and x <= 40 then


            local newSize =
                0.1 + ((x-21)/19)*1.9


            newSize =
                math.floor(newSize*10)/10



            if newSize < 0.1 then
                newSize = 0.1
            end


            if newSize > 2 then
                newSize = 2
            end



            appSize = newSize


            settings.appSize = appSize



            if settings.save then
                settings.save()
            end



            draw()

        end




    elseif event == "mouse_scroll" then


        scroll = scroll + button


        if scroll < 0 then
            scroll = 0
        end


        if scroll > 10 then
            scroll = 10
        end


        draw()



    elseif event == "key" then


        if button == keys.v then

            shell.run("startup")
            break

        end

    end


end