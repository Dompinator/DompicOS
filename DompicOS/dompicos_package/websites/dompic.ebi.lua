-- EBI Terminal - Epic Bureau Investigation

term.clear()
term.setCursorPos(1,1)

-- Draws the main menu
local function drawMenu()
    term.clear()
    term.setCursorPos(1,1)
    print("===================================")
    print("        EBI - EPIC BUREAU")
    print("            INVESTIGATION")
    print("===================================")
    print("")
    print("[1] About EBI")
    print("[2] Active Investigations")
    print("[3] Agents")
    print("[4] Contact")
    print("[5] Exit")
    print("")
end

-- Pause until user presses ENTER
local function pause()
    print("")
    print("Press ENTER to return...")
    read()
end

-- Main program loop
while true do
    drawMenu()
    write("> ")
    local choice = read()

    term.clear()
    term.setCursorPos(1,1)

    if choice == "1" then
        print("===== ABOUT EBI =====")
        print("")
        print("Epic Bureau Investigation (EBI)")
        print("is a Minecraft investigation agency.")
        print("")
        print("Mission:")
        print("- Investigate incidents")
        print("- Collect evidence")
        print("- Protect communities")

    elseif choice == "2" then
        print("===== ACTIVE CASES =====")
        print("")
        print("CASE #001")
        print("Status: Under Investigation")
        print("Location: Classified")
        print("")
        print("CASE #002")
        print("Status: Closed")

    elseif choice == "3" then
        print("===== EBI AGENTS =====")
        print("")
        print("Director: Epic")
        print("Agent Team: Classified")
        print("Security Level: High")

    elseif choice == "4" then
        print("===== CONTACT =====")
        print("")
        print("EBI Headquarters")
        print("Minecraft Network Terminal")
        print("Discord: EBI Official")

    elseif choice == "5" then
        print("Closing EBI terminal...")
        break

    else
        print("Invalid option.")
    end

    pause()
end
