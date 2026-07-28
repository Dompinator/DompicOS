-- DompicOS Online Installer v2

term.setBackgroundColor(colors.black)
term.clear()

local githubAPI = "https://api.github.com/repos/Dompinator/DompicOS/contents/DompicOS"
local rawBase = "https://raw.githubusercontent.com/Dompinator/DompicOS/main/DompicOS/"

print("================================")
print("       DompicOS Installer")
print("             v2.0")
print("================================")
print("")

sleep(1)


local function makeDir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end


local function downloadFile(url, path)

    print("Installing: " .. path)

    local response = http.get(url)

    if response then

        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()

        response.close()

        print(" [OK]")
        return true

    else

        print(" [FAILED]")
        return false

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

        local name = item.name
        local type = item.type

        local newLocalPath = localPath .. "/" .. name
        local newAPIPath = item.url


        if type == "file" then

            downloadFile(
                rawBase .. newLocalPath,
                newLocalPath
            )


        elseif type == "dir" then

            makeDir(newLocalPath)

            installFolder(
                newAPIPath,
                newLocalPath
            )

        end
    end
end



print("Creating folders...")
print("")

makeDir("apps")
makeDir("system")
makeDir("websites")
makeDir("images")
makeDir("sounds")

print("")
print("Downloading DompicOS...")
print("")


installFolder(
    githubAPI,
    ""
)


print("")
print("================================")
print(" Installation complete!")
print(" Restarting...")
print("================================")

sleep(3)

os.reboot()
