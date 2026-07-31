-- Dompic Browser
-- apps/browser.lua

local w,h = term.getSize()

local currentPage = "dompic.home"

local historyFile = "system/browser_history.cfg"



local function saveHistory(page)

    local history = {}

    if fs.exists(historyFile) then

        local f = fs.open(historyFile,"r")

        history = textutils.unserialize(
            f.readAll()
        ) or {}

        f.close()

    end


    for i=#history,1,-1 do

        if history[i] == page then
            table.remove(history,i)
        end

    end


    table.insert(history,page)


    while #history > 10 do
        table.remove(history,1)
    end


    local f = fs.open(historyFile,"w")

    f.write(
        textutils.serialize(history)
    )

    f.close()

end




local function openPage(page)

    currentPage = page

    saveHistory(page)


    local file = "websites/"..page..".lua"


    if fs.exists(file) then

        shell.run(file)

    else

        term.clear()

        term.setCursorPos(2,2)

        print("404")
        print("")
        print("Website not found:")
        print(page)

        sleep(2)

    end

end





-- START

saveHistory("dompic.home")

openPage("dompic.home")





while true do


    term.setBackgroundColor(colors.lightGray)

    term.clear()


    term.setCursorPos(2,1)

    write(currentPage)



    local event,button,x,y = os.pullEvent()



    -- Reboot

    if event == "key" and button == keys.v then

        os.reboot()

    end





    -- Klicka på adressfältet

    if event == "mouse_click" and y == 1 then


        term.setCursorPos(2,1)

        term.clearLine()


        local input = read()


        input = input:gsub("%s+", "")



        if input ~= "" then

            openPage(input)

        end


    end





    -- Tryck enter för att öppna adressen

    if event == "key" and button == keys.enter then


        term.setCursorPos(2,1)

        term.clearLine()


        local input = read()


        input = input:gsub("%s+", "")



        if input ~= "" then

            openPage(input)

        end


    end



end