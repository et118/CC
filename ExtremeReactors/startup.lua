local reactor
local active
local energy

local activateTreshold
local maxEnergyStorage
maxEnergyStorage = 10000000
activateTreshold = maxEnergyStorage - maxEnergyStorage*0.50
stopTreshold = maxEnergyStorage - maxEnergyStorage*0.10

reactor = peripheal.wrap("right")
if reactor.getConnected() == false then
    error("No Reactor Connected")
end

while true do
    active = reactor.getActive()
    energy = reactor.getEnergyStored()

    if active == false and energy < activateTreshold then
        reactor.setActive(true)
        active = true
    end
    if active == true and energy > stopTreshold then
        reactor.setActive(false)
        active = false
    end
    os.sleep(5)
end