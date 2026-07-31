local speaker = peripheral.find("speaker")

if not speaker then
    return
end

local decoder = require("cc.audio.dfpwm").make_decoder()

for chunk in io.lines("sounds/startup_sound.dfpwm", 16 * 1024) do
    speaker.playAudio(decoder(chunk))
    os.pullEvent("speaker_audio_empty")
end