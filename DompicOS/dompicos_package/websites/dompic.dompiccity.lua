-- DompicCity Wiki
-- websites/dompic.dompiccity.lua

local w, h = term.getSize()

local function center(text, y)
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end


term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.clear()


-- Titel
term.setTextColor(colors.orange)
center("DompicCity Wiki", 4)


-- Information
term.setTextColor(colors.black)

local lines = {
    "Välkommen till DompicCity!",
    "",
    "Vi hoppas att du kommer att gilla det här!",
    "",
    "Här är lite viktig information:",
    "",
    "För att få köra bil lär du ta ett",
    "DompicKörkort. Inget annat gäller.",
    "",
    "Du kommer att få bills i din brevlåda.",
    "Du måste skicka de till \"DPS\".",
    "",
    "Annars blir det court och ditt",
    "straff bestäms där.",
    "",
    "",
    "Mera kommer till denna webbsida senare."
}


local y = 7

for _, line in ipairs(lines) do
    term.setCursorPos(3, y)
    print(line)
    y = y + 1
end


-- Searchbar högst upp
term.setBackgroundColor(colors.lightGray)
term.setTextColor(colors.black)

term.setCursorPos(1,1)

for i = 1, w do
    write(" ")
end

term.setCursorPos(2,1)
write("dompic.dompiccity")


-- Skicka välkomstnotis
shell.run(
    "system/notify.lua",
    "DompicCity",
    "Välkommen till DompicCity!"
)


-- Vänta på klick
while true do

    local event, button, x, yClick = os.pullEvent("mouse_click")

    if yClick == 1 then

        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)

        term.setCursorPos(1,1)

        for i = 1, w do
            write(" ")
        end

        term.setCursorPos(2,1)

        local address = read()

        if address ~= "" then
            shell.run("websites/" .. address .. ".lua")
        end

    end

end