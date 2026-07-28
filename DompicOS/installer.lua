-- DompicOS Online Installer v2

term.setBackgroundColor(colors.black)
term.clear()

local rawBase = "https://raw.githubusercontent.com/Dompinator/DompicOS/main/DompicOS/"
local apiBase = "https://api.github.com/repos/Dompinator/DompicOS/contents/DompicOS"

print("================================")
print("       DompicOS Installer")
print("             v2.0")
print("================================")
print("")

sleep(1)


local function downloadFile(url, path)

    print("Installing: " .. path)

    local response = http.get(url)

    if response then

        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()

        response.close()

        print(" [OK]")

    else

        print(" [FAILED]")

    end
end


local function installFolder(apiPath, localPath)

    local response = http.get(apiPath)

    if not response then
        print("Cannot access:")
        print(apiPath)
        return
    end

    local data = textutils.unserializeJSON(response.readAll())
    response.close()


    for _, item in ipairs(data) do

        local newPath

        if localPath == "" then
            newPath = item.name
        else
            newPath = localPath .. "/" .. item.name
        end


        if item.type == "file" then

            downloadFile(
                rawBase .. newPath,
                newPath
            )


        elseif item.type == "dir" then

            if not fs.exists(newPath) then
                fs.makeDir(newPath)
            end

            installFolder(
                item.url,
                newPath
            )

        end

    end

end


print("Downloading DompicOS...")
print("")


installFolder(
    apiBase,
    ""
)


print("")
print("================================")
print(" Installation complete!")
print(" Restarting...")
print("================================")

sleep(3)

os.reboot()
