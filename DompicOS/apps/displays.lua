local displayFile = "system/display.cfg"

local monitor = peripheral.find("monitor")

term.clear()
term.setCursorPos(1,1)

print("Dompic Display")
print("----------------")
print()

if fs.exists(displayFile) then
    print("Status: Connected")
    print()
    print("[1] Disconnect Monitor")
else
    print("Status: Not Connected")
    print()
    print("[1] Connect Monitor")
end

local _, key = os.pullEvent("key")

if key == keys.one then

    if fs.exists(displayFile) then

        local f = fs.open(displayFile, "r")
        local side = f.readAll()
        f.close()

        local mon = peripheral.wrap(side)

        if mon then
            mon.clear()
        end

        fs.delete(displayFile)

        print("Monitor disconnected!")

    else

        if monitor then

            local f = fs.open(displayFile, "w")
            f.write(peripheral.getName(monitor))
            f.close()

            print("Monitor connected!")

        else

            print("No monitor found!")

        end
    end
end

sleep(2)