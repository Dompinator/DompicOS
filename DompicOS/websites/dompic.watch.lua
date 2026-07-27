-- Dompic.watch
-- websites/dompic.watch.lua

local w, h = term.getSize()


local function clear()
    term.setBackgroundColor(colors.black)
    term.clear()
end


local function home()

    clear()

    -- Green header
    term.setBackgroundColor(colors.green)
    paintutils.drawFilledBox(1,1,w,3)

    term.setTextColor(colors.white)
    term.setCursorPos(3,2)
    write("Dompic.watch")


    -- Video card

    term.setBackgroundColor(colors.gray)
    paintutils.drawFilledBox(5,6,w-5,12)


    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)

    term.setCursorPos(7,7)
    write("The Growing cock with the dancing stock...")

    term.setCursorPos(7,9)
    write("[ PLAY ]")

end



local function playVideo()

    local frames = {

[[

       O
      /|\
       |
      / \
]],

[[

       O
      \|/
       |
      / \
]],

[[

      \O/
       |
      / \
]],

[[

       O
      /|\
       |
       /\
]],

[[

      \O/
       |
      / \
]],

[[

       O
      /|\             
       |              
      / \           0  0
]],

[[

        O
      /|\             
       |              
      / \           0 | 0

]],

[[

            O
      /|\             
       |              |
      / \           0 | 0

]],

[[

           O
      /|\             |
       |              |
      / \           0 | 0

]],

[[

      \O/           o
       |             ---------
      / \           o
]]

    }


    for i = 1, #frames do

        clear()

        term.setBackgroundColor(colors.green)
        paintutils.drawFilledBox(1,1,w,3)

        term.setTextColor(colors.white)
        term.setCursorPos(3,2)
        write("Dompinat0r - The Growing cock with the dancing stock...")


        term.setCursorPos(
            math.floor(w/2)-3,
            7
        )

        print(frames[i])

        sleep(0.5)

    end


    home()

end



home()


while true do

    local event, button, x, y = os.pullEvent("mouse_click")


    if x >= 7 and x <= 16 and y == 9 then

        playVideo()

    end

end