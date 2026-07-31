-- Dompic Explorer

local w, h = term.getSize()

local sidebarWidth = 20

local currentPath = nil
local scroll = 0

local expanded = {}



local function hidden(name)

    return name == "rom"
    or name == "websites"

end



local function getFolders(path)

    local folders = {}

    if fs.exists(path) then

        for _,name in ipairs(fs.list(path)) do

            if not hidden(name)
            and fs.isDir(path.."/"..name) then

                table.insert(
                    folders,
                    name
                )

            end

        end

    end

    return folders

end




local function getContents(path)

    local contents = {}

    if fs.exists(path) then

        for _,name in ipairs(fs.list(path)) do

            if not hidden(name) then

                table.insert(
                    contents,
                    name
                )

            end

        end

    end

    return contents

end




-- Draw folder tree

local function drawTree(path, prefix, y)


    for _,folder in ipairs(getFolders(path)) do


        if y > h then
            return y
        end



        local fullPath =
            path.."/"..folder



        term.setCursorPos(
            prefix,
            y
        )



        if expanded[fullPath] then

            write("v "..folder)

        else

            write("> "..folder)

        end



        y = y + 1




        if expanded[fullPath] then


            local oldY = y


            y = drawTree(
                fullPath,
                prefix + 2,
                y
            )



            -- Empty folder space

            if y == oldY then

                y = y + 1

            end


        end


    end


    return y

end





local function draw()


    term.setBackgroundColor(colors.lime)
    term.clear()



    -- Pink side

    term.setBackgroundColor(colors.pink)

    paintutils.drawFilledBox(
        1,
        1,
        sidebarWidth,
        h
    )



    term.setTextColor(colors.white)


    term.setCursorPos(2,2)

    write("Dompic Explorer")



    local y = 5



    if expanded["/"] then

        term.setCursorPos(2,y)

        write("v My Computer")

    else

        term.setCursorPos(2,y)

        write("> My Computer")

    end



    y = y + 1



    if expanded["/"] then

        drawTree(
            "/",
            3,
            y
        )

    end





    -- Green side

    term.setBackgroundColor(colors.lime)

    paintutils.drawFilledBox(
        sidebarWidth + 1,
        1,
        w,
        h
    )



    term.setTextColor(colors.black)



    if currentPath == nil then


        term.setCursorPos(
            sidebarWidth + 3,
            6
        )

        write("My Computer")


        return

    end




    term.setCursorPos(
        sidebarWidth + 2,
        3
    )

    write(
        "Location: "..currentPath
    )



    local contents =
        getContents(currentPath)



    local y2 = 5 - scroll



    for _,name in ipairs(contents) do


        if y2 >= 5
        and y2 <= h then


            term.setCursorPos(
                sidebarWidth + 3,
                y2
            )



            if fs.isDir(
                currentPath.."/"..name
            ) then

                write("[DIR]  "..name)

            else

                write("[FILE] "..name)

            end


        end


        y2 = y2 + 1


    end


end





-- Find clicked folder in tree

local function getTreeClick(path, y, prefix)


    for _,folder in ipairs(getFolders(path)) do


        if y == prefix then

            return path.."/"..folder

        end


        prefix = prefix + 1



        local full =
            path.."/"..folder



        if expanded[full] then


            local result =
                getTreeClick(
                    full,
                    y,
                    prefix + 1
                )


            if result then
                return result
            end



            prefix = prefix +
                #getFolders(full)

        end


    end


    return nil

end





draw()



while true do


    local event, button, x, y =
        os.pullEvent()



    if event == "mouse_click" then



        -- My Computer

        if x <= sidebarWidth
        and y == 5 then


            expanded["/"] =
                not expanded["/"]


            currentPath = "/"


            scroll = 0


            draw()


        end




        -- Pink tree click

        if x <= sidebarWidth
        and y > 5 then


            local folder =
                getTreeClick(
                    "/",
                    y,
                    6
                )


            if folder then


                expanded[folder] =
                    not expanded[folder]


                currentPath = folder


                scroll = 0


                draw()


            end


        end




        -- Green area click

        if x > sidebarWidth
        and currentPath ~= nil
        and y >= 5 then


            local index =
                y - 4 + scroll


            local contents =
                getContents(currentPath)



            local selected =
                contents[index]



            if selected then


                local path =
                    currentPath.."/"..selected



                if fs.isDir(path) then


                    currentPath = path

                    expanded[path] = true

                    scroll = 0

                    draw()


                else

                    shell.run(path)

                    draw()

                end


            end


        end




        -- Right click back

        if button == 2 then


            if currentPath ~= nil then


                if currentPath == "/" then

                    currentPath = nil

                else

                    currentPath =
                        fs.getDir(currentPath)

                end


                scroll = 0


                draw()


            end


        end


    end





    -- Scroll green area

    if event == "mouse_scroll" then


        if x == nil
        or x > sidebarWidth then


            scroll = scroll + button


            if scroll < 0 then
                scroll = 0
            end



            local max =
                #getContents(currentPath or "/")
                - (h - 5)



            if scroll > max then

                scroll = math.max(max,0)

            end



            draw()


        end


    end


end