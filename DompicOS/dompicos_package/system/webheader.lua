local w = term.getSize()

local function header(address)

    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)

    term.setCursorPos(1,1)
    write(" " .. address)

    for i = #address + 2, w do
        write(" ")
    end

    term.setCursorPos(1,2)
    term.setBackgroundColor(colors.white)
    term.clearLine()
end


return header