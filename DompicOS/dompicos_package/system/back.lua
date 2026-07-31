-- DompicOS Back Button
-- system/back.lua

while true do

    local event, key = os.pullEvent("key")

    if key == keys.v then

        shell.run("startup")
        break

    end

end