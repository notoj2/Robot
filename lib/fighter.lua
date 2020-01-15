Fighter = Object:extend()

-- update x, y
local function updateHand(self, index)
    local hand = {}
    local len = self.radius

    local dir = math.pi/4
    if index == 1 then
        dir = -dir
    end

    --
    hand.x = self.x + base.dir_getXY(self.dir+dir, len, "x")
    hand.y = self.y + base.dir_getXY(self.dir+dir, len, "y")

    return hand
end
-- get punch len*mode
local function getPunchLen(self)
    local mode = 0

    if self.punchTimer < self.attackBefore then
        mode = self.punchTimer/self.attackBefore
    elseif self.punchTimer > self.attackAfter then
        mode = (self.punchTimerMax-self.punchTimer)/(self.punchTimerMax-self.attackAfter)
    else
        mode = 1
    end

    return mode*self.punchLen
end

function Fighter:new(x, y, dir, cLine)
    -- body
    self.x = x
    self.y = y
    self.spdX = 0
    self.spdY = 0
    self.dir = dir
    self.cLine = base.cWhite
    if cLine~=nil then
        self.cLine = cLine
    end
    self.radius = 25
    -- hand
    self.handRadius = 12
    self.handList = {}
    for i = 1, 2 do
        self.handList[i] = updateHand(self, i)
    end

    -- punch
    self.punch = false
    self.punchHand = 0 -- record hand index
    self.punchLen = 25
    self.punchTimer = 0 -- fps
    self.punchTimerMax = 20

    -- attack
    self.attackBefore = 6
    self.attackAfter = self.punchTimerMax - 6
    self.attackList = {}

    self.beAttack = false
    self.beAttackDir = 0
    self.beAttackTimer = 0
    self.beAttackTimerMax = 10
    self.beAttackDis = 25
end


function Fighter:update(dt, leftPunch, rightPunch, fighterList)
    self.spdX = 0
    self.spdY = 0

    -- updateHand xy
    for i, value in ipairs(self.handList) do
        self.handList[i] = updateHand(self, i)
    end

    -- beAttack
    if self.beAttack then
        local dis = self.beAttackDis/self.beAttackTimerMax

        self.spdX = base.dir_getXY(self.beAttackDir, dis, 'x')
        self.spdY = base.dir_getXY(self.beAttackDir, dis, 'y')
        
        self.beAttackTimer = self.beAttackTimer + 1
        if self.beAttackTimer >= self.beAttackTimerMax then
            self.beAttackTimer = 0
            self.beAttack = false
        end
    else
        -- control
        if not self.punch then
            if leftPunch then
                self.punch = true
                self.punchHand = 2
            elseif rightPunch then
                self.punch = true
                self.punchHand = 1
            end
        end
    end
    
    -- punch
    if self.punch then
        self.punchTimer = self.punchTimer + 1

        local sign = 0
        if self.punchHand == 1 then
            sign = 1
        elseif self.punchHand == 2 then
            sign = -1
        end

        -- move
        if self.punchTimer >= self.attackBefore then
            self.dir = self.dir + math.pi/4/self.punchTimerMax*sign
            self.spdX = base.dir_getXY(self.dir, self.radius/self.punchTimerMax, "x")
            self.spdY = base.dir_getXY(self.dir, self.radius/self.punchTimerMax, "y")
        end

        -- attack
        if self.punchTimer > self.attackBefore and self.punchTimer < self.attackAfter then
            for index, fighter in ipairs(fighterList) do
                -- exist, pass
                if base.tableExist(self.attackList, fighter) then
                    break
                end

                -- attack
                if self:collision(fighter.x, fighter.y, fighter.radius) then
                    table.insert(self.attackList, fighter)
                    fighter.beAttack = true
                    fighter.beAttackDir = self.dir
                end
            end
        end

        -- finish
        if self.punchTimer >= self.punchTimerMax then
            self.punchTimer = 0
            self.punch = false
            self.attackList = {}
        end
    end

    -- set spd
    self.x = self.x + self.spdX
    self.y = self.y + self.spdY

    -- set dir
    if self.dir > math.pi*2 then
        self.dir = self.dir - math.pi*2
    elseif self.dir < 0 then
        self.dir = math.pi*2 - self.dir
    end
end


function Fighter:draw()
    love.graphics.setColor(self.cLine)
    -- body
    love.graphics.circle("line", self.x, self.y, self.radius)
    --base.drawCircle(self.x, self.y, self.radius)
    
    -- dir
    local xDis = base.dir_getXY(self.dir, self.radius, "x")
    local yDis = base.dir_getXY(self.dir, self.radius, "y")
    love.graphics.line(self.x, self.y, self.x+xDis, self.y+yDis)

    -- hand
    for i, hand in ipairs(self.handList) do
        --base.drawCircle(hand.x, hand.y, self.handRadius)
        love.graphics.circle("line", hand.x, hand.y, self.handRadius)

        if self.punch and i == self.punchHand then
            local xDis = base.dir_getXY(self.dir, getPunchLen(self), "x")
            local yDis = base.dir_getXY(self.dir, getPunchLen(self), "y")
            love.graphics.circle("line", hand.x + xDis, hand.y + yDis, self.handRadius)
            --base.drawCircle(hand.x+xDis, hand.y+yDis, self.handRadius)
        end
    end
end


function Fighter:collision(x, y, radius)
    local hand = self.handList[self.punchHand]
    local xDis = base.dir_getXY(self.dir, getPunchLen(self), "x")
    local yDis = base.dir_getXY(self.dir, getPunchLen(self), "y")

    local flag = base.getCollisionCircle(hand.x+xDis, hand.y+yDis, self.handRadius, x, y, radius)

    return flag
end