FighterAI = Fighter:extend()

local function getPunchDir(self, fighterList)
    local flag = false

    -- get player
    local player = 0
    for index, fighter in ipairs(fighterList) do
        if fighter:is(Player) then
            player = fighter
        end
    end

    --
    local dis = 10
    local x2 = self.x + base.dir_getXY(self.dir, dis, 'x')
    local y2 = self.y + base.dir_getXY(self.dir, dis, 'y')

    if self.x == x2 then
        if player.x < self.x then
            flag = true
        end
    elseif self.y == y2 then
        if player.y > self.y then
            flag = true
        end
    else
        local a = (y2-self.y)/(x2-self.x)
        local c = self.y-a*self.x
        local sign = base.sign(x2-self.x)

        if player.y*sign > (a*player.x+c)*sign then
            flag = true
        end
    end


    return not flag, flag
end

function FighterAI:new(x, y, dir, cLine)
    FighterAI.super.new(self, x, y, dir, cLine)
    
    self.leftPunch = false
    self.rightPunch = false

    self.randomPunch = false
    self.randomTimer = 0
    self.randomTimerMax = 0
end


function FighterAI:update(dt, fighterList)
    -- wait
    if self.randomPunch then
        self.leftPunch = false
        self.rightPunch = false

        self.randomTimer = self.randomTimer + 1

        if self.randomTimer >= self.randomTimerMax then
            self.randomTimer = 0
            self.randomPunch = false
        end
    end
    
    -- AI
    if not base.tableEmpty(fighterList) and not self.randomPunch then
        self.leftPunch, self.rightPunch = getPunchDir(self, fighterList)
        self.randomTimerMax = love.math.random(60, 50)
        self.randomPunch = true
    end
    --
    FighterAI.super.update(self, dt, self.leftPunch, self.rightPunch, fighterList)

    --FighterAI.super.update(self, dt, base.isPressed(keys.left), base.isPressed(keys.right), fighterList)
end


-- test
--[[
function FighterAI:draw()
    FighterAI.super.draw(self)

    for i = 1, base.guiWidth, 5 do
        for j = 1, base.guiHeight, 5 do
            local flag = false

            local dis = 10
            local x2 = self.x + base.dir_getXY(self.dir, dis, 'x')
            local y2 = self.y + base.dir_getXY(self.dir, dis, 'y')

            if self.x == x2 then
                if i < self.x then
                    flag = true
                end
            elseif self.y == y2 then
                if j > self.y then
                    flag = true
                end
            else
                local a = (y2-self.y)/(x2-self.x)
                local c = self.y-a*self.x
                local sign = base.sign(x2-self.x)

                if j*sign > (a*i + c)*sign then
                    flag = true
                end
            end

            if flag then
                love.graphics.setColor(base.cYellow)
                love.graphics.points(i, j)
            end
        end
    end
end
]]