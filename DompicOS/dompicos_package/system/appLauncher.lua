-- DompicOS App Launcher
-- system/appLauncher.lua

local app = ...

if not app then
    return
end


local function startApp()

    shell.run("apps/" .. app)

end


local function backWatcher()

    while true do

        local event, key = os.pullEvent("key")

        if key == keys.v then

            error("DOMPIC_EXIT")

        end

    end

end


local success, err = pcall(function()

    parallel.waitForAny(
        startApp,
        backWatcher
    )

end)


term.setBackgroundColor(colors.blue)
term.clear()

shell.run("startup")