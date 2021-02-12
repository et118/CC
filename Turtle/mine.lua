local oreTable = {"gold_ore","iron_ore","coal_ore","diamond_ore","ore_metal","resource","oreyellorite","ore","resonating_ore","ore_cinnabar","block_misc","lapis_ore","redstone_ore","emerald_ore","quartz_ore","charged_quartz_ore","gem_ore","resources","orebenitoite","dimensional_shard_ore","ore_magic","ore_quartz","stygianironore","coal","diamond","dye","emerald","quartz","material","resource_item","gem","mineralbenitoite","dimensional_shard","redstone","ingredients","item_crystal","apatite"}
local pos = vector.new(gps.locate())
local direction
args = {...}
function getBlockName(block)
    local iter = 0
    for i in string.gmatch(block,"([^:]+)") do
        if iter == 1 then
            blockName = i
            return blockName
        end
        iter = iter + 1
    end
end

function ivFull()
    local full = true
    for i = 1,16 do
        if turtle.getItemCount(i) == 0 then
            full = false
            break
        end
    end
    return full
end

function dropUnwantedOres()
    for i=1,16,1 do
        local item
        local shouldDrop = true
        item = turtle.getItemDetail(i)
        if item ~= nil then
            item = getBlockName(item.name)
            for j=1, #oreTable do
                local ore = oreTable[j]
                if ore == item then
                    shouldDrop = false
                    break
                end
            end
            if shouldDrop == true then
                turtle.select(i)
                turtle.drop()
            end
        end
    end
end

function shouldMineBlock(block)
    local blockName = getBlockName(block)
    local iter = 0
    local shouldMine = false

    for i=1, #oreTable do
        local ore = oreTable[i]
        if ore == blockName then
            shouldMine = true
            return true
        end
    end
end

function mineBlockAction(success,data,dir)
    if success then
        if shouldMineBlock(data.name) then
            if dir == 0 then
                turtle.digUp()
            elseif dir == 1 then
                turtle.digDown()
            else
                turtle.dig()
            end
        else
            return
        end
    else
        return
    end
end

function mineOres()
    s1,d1 = turtle.inspectUp()
    mineBlockAction(s1,d1,0)
    s2,d2 = turtle.inspectDown()
    mineBlockAction(s2,d2,1)

    turtle.turnLeft()
    s3,d3 = turtle.inspect()
    mineBlockAction(s3,d3,3)
    turtle.turnRight()

    turtle.turnRight()
    s4,d4 = turtle.inspect()
    mineBlockAction(s4,d4,3)
    turtle.turnLeft()
end

function goTo(x,y,z,shouldMineOres)
    local gotoPos = vector.new(x,y,z)
    local displacement = gotoPos - pos
    
    if direction == nil then
        turtle.dig()
        turtle.forward()
        local pos2 = vector.new(gps.locate())
        turtle.back()
        local difference = pos2 - pos
        if difference.x == 1 then
            direction = 1
        elseif difference.x == -1 then
            direction = 3
        end
        if difference.z == 1 then
            direction = 2
        elseif difference.z == -1 then
            direction = 0
        end
    end
    if displacement.y > 0 then
        for i=1,displacement.y,1 do
            turtle.digUp()
            turtle.up()
            if shouldMineOres then
                mineOres()
            end
        end
    elseif displacement.y < 0 then
        for i=-1,displacement.y,-1 do
            turtle.digDown()
            turtle.down()
            if shouldMineOres then
                mineOres()
            end
        end
    end

    if displacement.x > 0 then
        while direction ~= 1 do
            turtle.turnRight()
            direction = direction + 1
            if direction >= 4 then
                direction = 0
            end
        end
        for i=1, displacement.x, 1 do
            turtle.dig()
            turtle.forward()
            if shouldMineOres then
                mineOres()
            end
        end
    elseif displacement.x < 0 then
        while direction ~= 3 do
            turtle.turnLeft()
            direction = direction - 1
            if direction <= -1 then
                direction = 3
            end
        end
        for i=-1,displacement.x,-1 do
            turtle.dig()
            turtle.forward()
            if shouldMineOres then
                mineOres()
            end
        end
    end

    if displacement.z > 0 then
        while direction ~= 2 do
            turtle.turnRight()
            direction = direction + 1
            if direction >= 4 then
                direction = 0
            end
        end
        for i=1, displacement.z, 1 do
            turtle.dig()
            turtle.forward()
            if shouldMineOres then
                mineOres()
            end
        end
    elseif displacement.z < 0 then
        while direction ~= 0 do
            turtle.turnLeft()
            direction = direction - 1
            if direction <= -1 then
                direction = 3
            end
        end
        for i=-1,displacement.z,-1 do
            turtle.dig()
            turtle.forward()
            if shouldMineOres then
                mineOres()
            end
        end
    end
end

function mineArea(width,length)

    width = math.ceil(width/3)
    local turn = 1
    local home = 1
    
    for w=1,width,1 do
        for l=1,length,1 do
            turtle.dig()
            turtle.forward()
            mineOres()
        end
        turtle.dig()
        turtle.forward()
        if turn == 1 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
        turtle.dig()
        turtle.forward()
        turtle.dig()
        turtle.forward()
        turtle.dig()
        turtle.forward()
        if turn == 1 then
            turtle.turnRight()
            turn = 0
        else
            turtle.turnLeft()
            turn = 1
        end
        
        if home == 1 then
            home = 0
            dropUnwantedOres()
        else
            home = 1
        end
        if home == 1 and ivFull() == true then
            turtle.turnLeft()
            for i=1,w*3,1 do
                turtle.dig()
                turtle.forward()
            end
            dropUnwantedOres()
            turtle.turnLeft()
            shell.run("refuel all")
            for i=1,16,1 do
                turtle.select(i)
                turtle.drop()
            end
            turtle.turnLeft()
            for i=1,w*3,1 do
                turtle.dig()
                turtle.forward()
            end
            turtle.turnLeft()
        end
    end
    if home == 0 then
        turtle.turnRight()
        turtle.forward()
        turtle.forward()
        turtle.forward()
        turtle.turnLeft()
        for i=1,length,1 do
            turtle.forward()
        end
        turtle.forward()
        turtle.turnLeft()
        turtle.turnLeft()
        home = 1
        width = width - 1
    end
    turtle.turnLeft()
    for i=1,width*3,1 do
        turtle.dig()
        turtle.forward()
    end
    dropUnwantedOres()
    turtle.turnLeft()
    for i=1,16,1 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnRight()
    turtle.turnRight()
end

mineArea(args[1],args[2])