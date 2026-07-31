-- DompicOS Boot Animation

local w, h = term.getSize()

term.setBackgroundColor(colors.black)
term.clear()


-- Startup sound (runs in background)
local function playSound()
    if fs.exists("sounds/startup_sound.dfpwm") then
        local speaker = peripheral.find("speaker")

        if speaker then
            local decoder = require("cc.audio.dfpwm").make_decoder()

            for chunk in io.lines("sounds/startup_sound.dfpwm", 16 * 1024) do
                speaker.playAudio(decoder(chunk))
                os.pullEvent("speaker_audio_empty")
            end
        end
    end
end


-- Draw triangle
local function drawTriangle(size, color)
    local centerX = math.floor(w / 2)
    local centerY = math.floor(h / 2)

    term.setBackgroundColor(color)

    for y = 0, size do
        local width = math.floor(y / 2)
        local startX = centerX - width
        local posY = centerY - math.floor(size / 2) + y

        if posY >= 1 and posY <= h then
            term.setCursorPos(startX, posY)
            term.write(string.rep(" ", width * 2))
        end
    end
end


-- Triangle animation only controls boot timing
local function triangleAnimation()

    local maxSize = math.max(w, h)

    for size = 1, maxSize, 2 do

        term.setBackgroundColor(colors.black)
        term.clear()

        -- Orange outer triangle
        drawTriangle(size, colors.orange)

        -- Blue inner triangle (half size)
        drawTriangle(math.floor(size / 2), colors.lightBlue)

        sleep(0.075)
    end

end


-- Start sound and animation together
parallel.waitForAny(
    triangleAnimation,
    playSound
)


-- Immediately continue to DompicOS
term.setBackgroundColor(colors.black)
term.clear()