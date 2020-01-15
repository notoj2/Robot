local base = {}


--- gui
base.guiWidth = love.graphics.getWidth()
base.guiHeight = love.graphics.getHeight()
base.guiBorder = base.guiWidth/30
base.fontHeight = love.graphics.getFont():getHeight()


--- color
base.cBlack = {0, 0, 0}
base.cWhite = {1, 1, 1}
base.cYellow = {1, 1, 0}
base.cRed = {1, 0, 0}
base.cBlue = {0, 0, 1}
base.cGray = {0.5, 0.5, 0.5}
base.cDarkGray = {0.25, 0.25, 0.25}
base.cPlayer1 = {207/255, 51/255, 47/255}


--- func
-- better text print. xMode using love.graphics.printf(), yMode get font's pixels height and move x/y
function base.print(string, x, y, xMode, yMode)
    -- xMode
    if xMode == nil and yMode == nil then
        love.graphics.print(string, x, y)
    else
        local w = love.graphics.getFont():getWidth(string) * 2
        local h = base.fontHeight
        local y2 = y
        local xMode2 = xMode -- more usual
        -- yMode
        if yMode == "top" or yMode == nil then
            --default
        elseif yMode == "center" then
            y2 = math.floor(y - h/2)
        elseif yMode == "bottom" then
            y2 = y - h
        else
            error("Invalid alignment " .. yMode .. ", expected one of: 'top','center','bottom'");
        end
        
        if xMode ~= nil then
            if xMode == "left" then
                xMode2 = "right"
            elseif xMode == "right" then
                xMode2 = "left"
            end
        end
        love.graphics.printf(string, math.floor(x-w/2), y2, w, xMode2)
    end
end

-- isDown
local joysticks = love.joystick.getJoysticks()
local joystick = joysticks[1]
function base.isDown(keyName)
    return love.keyboard.isDown(keyName.keyboard) or (joystick ~= nil and joystick:isGamepadDown(keyName.gamepad))
end
function base.isPressed(keyName)
    return keyName.isPressed
end
function base.pressedSetting(keys, dt)
    for key, keyName in pairs(keys) do
        local flag = false
        -- reset
        --[[
        if not base.isDown(keyName) then
            keyName.released = true
            keyName.timerMax = 0
            keyName.timer = 0
        else
            keyName.timer = keyName.timer + dt
            if keyName.timerMax == 0 then   -- only 1 frame
                keyName.timerMax = dt
            end

            -- only 1 frame
            if keyName.timer > keyName.timerMax then
                keyName.released = false
            end

            if keyName.released then
                flag = true
            end
        end
        ]]

        if base.isDown(keyName) then
            if keyName.released then
                flag = true
                keyName.released = false
            end
        else
            keyName.released = true
        end

        --
        keyName.isPressed = flag
    end

    return keys
end

-- use dir get XY
function base.dir_getXY(dir, dis, xyMode)
    local x = math.cos(dir)*dis
    local y = math.sin(dir)*dis
    
    if xyMode == "x" then
        return x
    elseif xyMode == "y" then
        return y
    else
        return x, y
    end
end

-- dis between two point
function base.getDis(x1, y1, x2, y2)
    local disX = math.abs(x1 - x2)
    local disY = math.abs(y1 - y2)

    return (disX^2 + disY^2)^0.5
end

-- collision between two circle
function base.getCollisionCircle(x1, y1, radius1, x2, y2, radius2)
    local dis = base.getDis(x1, y1, x2, y2)

    return dis <= radius1+radius2
end

-- clone table
function base.tableClone(table)
    local t1 ={}--new table
    for i = 1, #table do
        t1[i] = table[i]
    end

    return t1
end

-- clone table
function base.tableExist(table, value)
    local flag = false

    for index, _value in ipairs(table) do
        if _value == value then
            flag = true
            break
        end
    end

    return flag
end

-- sign
function base.sign(number)
    if number > 0 then
        return 1
    elseif number < 0 then
        return -1
    else
        return 0
    end
end


-- table nil
function base.tableEmpty(table)
    return _G.next(table) == nil
end


-- draw circle
function base.drawCircle(x, y, radius)
    love.graphics.circle('fill', x, y, radius)

    love.graphics.setColor(base.cWhite)
    love.graphics.circle('line', x, y, radius)
    
    --[[
    local dis = ((base.guiWidth/2)^2 + (base.guiHeight/2)^2)^0.5 + radius

    local rateX = (base.guiWidth/2 - x)/dis
    local rateY = (base.guiHeight/2 - y)/dis

    local disX = -radius*rateX
    local disY = -radius*rateY

    local radius2 = radius + 2

    love.graphics.setColor(base.cWhite)
    love.graphics.circle('line', x, y, radius)

    love.graphics.setColor(base.cBlack)
    love.graphics.circle('fill', x+disX, y+disY, radius2)
    love.graphics.setColor(base.cWhite)
    love.graphics.circle('line', x+disX, y+disY, radius2)
    ]]
end


return base