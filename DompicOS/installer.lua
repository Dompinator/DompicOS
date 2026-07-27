-- DompicOS Online Installer

term.setBackgroundColor(colors.black)
term.clear()

local version = "1.0.0"

-- ÄNDRA DENNA TILL DIN GITHUB-LÄNK
local github = "https://raw.githubusercontent.com/DITT_NAMN/DompicOS/main/"

print("================================")
print("        DompicOS Installer")
print("================================")
print("")
print("Version: " .. version)
print("")

sleep(1)


local function download(url, path)
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


local function makeDir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end


print("Creating folders...")

local folders = {
    "apps",
    "system",
    "websites",
    "images",
    "sounds"
}

for _, folder in ipairs(folders) do
    makeDir(folder)
end

print("Folders created!")
print("")


local files = {

    -- Main system
    "startup.lua",

    -- System
    "system/settings.lua",
    "system/boot_animation.lua",
    "system/version.cfg",

    -- Apps
    "apps/browser.lua",
    "apps/explorer.lua",
    "apps/settings.lua",

    -- Websites
    "websites/dompic.home.lua",
    "websites/dompic.dfe.lua",

    -- Sounds
    "sounds/startup_sound.dfpwm"
}


print("Downloading DompicOS files...")
print("")


for _, file in ipairs(files) do
    download(
        github .. file,
        file
    )

    sleep(0.2)
end


print("")
print("================================")
print(" Installation complete!")
print(" Restarting...")
print("================================")

sleep(3)

os.reboot()
