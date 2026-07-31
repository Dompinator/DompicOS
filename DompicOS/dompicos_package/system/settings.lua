-- DompicOS Settings Storage
-- system/settings.lua

local path = "system/settings.cfg"


local settings = {
    background = "bright_blue",
    appSize = 1
}



-- Load saved settings

if fs.exists(path) then

    local file = fs.open(path,"r")

    local data = textutils.unserialize(
        file.readAll()
    )

    file.close()


    if data then

        if data.background then
            settings.background = data.background
        end


        if data.appSize then
            settings.appSize = tonumber(data.appSize)
        end

    end

end



-- Save only the values (NOT functions)

function settings.save()

    local saveData = {

        background = settings.background,

        appSize = settings.appSize

    }


    local file = fs.open(path,"w")

    file.write(
        textutils.serialize(saveData)
    )

    file.close()

end



return settings