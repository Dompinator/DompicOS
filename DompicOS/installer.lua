-- DompicOS Installer

term.setBackgroundColor(colors.black)
term.clear()

print("DompicOS Installer")
print("")
sleep(1)

local base = "https://raw.githubusercontent.com/Dompinator/DompicOS/refs/heads/main/DompicOS/dompicos_package/"

print("Downloading file list...")
print("")

-- Download manifest
shell.run("wget " .. base .. "manifest.lua manifest.lua")

if not fs.exists("manifest.lua") then
    print("ERROR: Could not download manifest.lua!")
    return
end

local files = dofile("manifest.lua")

print("")
print("Installing DompicOS...")
print("")

-- Download every file from manifest
for _, file in ipairs(files) do

    local folder = fs.getDir(file)

    if folder ~= "" and not fs.exists(folder) then
        fs.makeDir(folder)
    end

    print("Downloading: " .. file)

    shell.run(
        "wget " ..
        base .. file ..
        " " .. file
    )

    if fs.exists(file) then
        print("[OK] " .. file)
    else
        print("[FAILED] " .. file)
    end

    sleep(0.2)
end


print("")
print("Installation complete!")
print("Restarting in 3 seconds...")

-- Remove temporary manifest
fs.delete("manifest.lua")

sleep(3)

os.reboot()
