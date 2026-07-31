-- DompicOS Installer

term.setBackgroundColor(colors.black)
term.clear()

print("DompicOS Installer")
print("")
sleep(1)

print("Downloading DompicOS package...")
print("")

fs.makeDir("dompicos_package")

shell.run("wget https://raw.githubusercontent.com/Dompinator/DompicOS/refs/heads/main/DompicOS/dompicos_package/startup.lua dompicos_package/startup.lua")

print("Download complete!")
sleep(1)

local package = "dompicos_package"

if not fs.exists(package) then
    print("ERROR: dompicos_package missing!")
    return
end

local function copyFile(from, to)
    local input = fs.open(from, "rb")
    local output = fs.open(to, "wb")

    output.write(input.readAll())

    input.close()
    output.close()
end

local function copyFolder(from, to)
    if not fs.exists(to) then
        fs.makeDir(to)
    end

    for _, file in ipairs(fs.list(from)) do
        local oldPath = from .. "/" .. file
        local newPath = to .. "/" .. file

        if fs.isDir(oldPath) then
            copyFolder(oldPath, newPath)
        else
            copyFile(oldPath, newPath)
        end
    end
end


print("Installing DompicOS...")
print("")

local items = {
    "startup.lua",
    "apps",
    "system",
    "websites",
    "images",
    "sounds"
}

for _, item in ipairs(items) do
    local source = package .. "/" .. item

    if fs.exists(source) then
        if fs.isDir(source) then
            copyFolder(source, item)
        else
            copyFile(source, item)
        end

        print("[OK] " .. item)
    end

    sleep(0.3)
end


print("")
print("Installation complete!")
print("Restarting in 3 seconds...")

sleep(3)

os.reboot()
