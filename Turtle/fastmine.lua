local args = {...}
local mining = false
local id = os.getComputerID()
function command(message,modem,senderChannel,replyChannel)
    if message == "TurtleStart" .. id then
        mining = true
    elseif message == "getStatus" .. id then
        modem.transmit(replyChannel,107,tostring(mining))
    elseif message == "getStatus" then
        modem.transmit(replyChannel,107,id .. ":" .. tostring(mining))
    end
end

function commandListener()
    local channel = tonumber(args[1])
    local running = true
    local modem = peripheral.wrap("left")
    modem.open(channel)
    while running == true do
        local e,m,senderChannel,replyChannel,message,d = os.pullEvent("modem_message")
        command(message,modem,senderChannel,replyChannel)
    end
end

function mine()
    while mining ~= true do
        os.sleep(1)
    end
    print("mining")

end

parallel.waitForAll(commandListener,mine)