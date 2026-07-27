-- DompicOS Startup

local w, h = term.getSize()

-- DompicOS Boot Animation
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

        term.setBackgroundColor(
            colors[bg] or colors.blue
        )

    end


    term.clear()



    -- Taskbar

    term.setBackgroundColor(colors.gray)

    paintutils.drawFilledBox(
        1,
        h,
        w,
        h
    )



    -- Start button

    term.setBackgroundColor(colors.orange)

    paintutils.drawFilledBox(
        1,
        h,
        5,
        h
    )


    term.setTextColor(colors.white)

    term.setCursorPos(3,h)

    write(">")



    -- Settings button

    term.setBackgroundColor(colors.lightGray)

    paintutils.drawFilledBox(
        10,
        h,
        12,
        h
    )



    -- Explorer button

    term.setBackgroundColor(colors.yellow)

    paintutils.drawFilledBox(
        15,
        h,
        17,
        h
    )



    -- Apps

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
            string.sub(name,1,boxWidth-1)
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

end






local function drawMenu()

    term.setBackgroundColor(colors.orange)

    paintutils.drawFilledBox(
        1,
        h-9,
        22,
        h-1
    )

    term.setTextColor(colors.white)

    term.setCursorPos(3,h-8)
    write("DompicOS")

    term.setCursorPos(3,h-7)
    write("Version 1.0")

    term.setCursorPos(3,h-5)
    write("----------------")

    term.setCursorPos(3,h-3)
    write("Reset")

    term.setCursorPos(3,h-2)
    write("Shutdown")

end




drawDesktop()






while true do

    local event, button, x, y = os.pullEvent()



    if event == "mouse_click" then



        -- Settings

-- Settings

if x >= 10
and x <= 12
and y == h then

    shell.run(
        "apps/settings.lua"
    )

    drawDesktop()

end



        -- Explorer

        if x >= 15
        and x <= 17
        and y == h then


            shell.run(
                "apps/explorer.lua"
            )


            drawDesktop()

        end





        -- Start

        if x <= 5
        and y == h then


            menuOpen = true

            drawMenu()

        end





        -- Menu buttons

        if menuOpen then


            if y == h-5 then

                os.reboot()


            elseif y == h-3 then

                os.shutdown()


            end

        end





        -- Apps

        for _, app in ipairs(appPositions) do


            if x >= app.x
            and x <= app.x + app.width
            and y >= app.y
            and y <= app.y + app.height then


                shell.run(
                    "apps/" .. app.name
                )


                drawDesktop()

            end

        end





    elseif event == "key" then


        if button == keys.v then

            os.reboot()

        end


    end


end