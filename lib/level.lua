Level = Screen:extend()

function Level:activate()
    self.fighterList = {}
    
    self.finish = false
    self.loserIndex = 0

    self.backTimer = 0
    self.backTimerMax = 60
end


function Level:update(dt)
    for i, fighter in ipairs(self.fighterList) do
        -- remove itself
        local _list = {}
        if not self.finish then
            _list = base.tableClone(self.fighterList)
            table.remove(_list, i)
        end
        
        -- update
        fighter:update(dt, _list)
        if not self.finish then
            if not base.getCollisionCircle(fighter.x, fighter.y, fighter.radius, base.guiWidth/2, base.guiHeight/2, base.guiHeight/2) then
                self.finish = true
                self.loserIndex = i
            end
        end
    end

    -- back mainScreen
    if base.isDown(keys.B) then
        self.backTimer = self.backTimer + 1
        if self.backTimer >= self.backTimerMax then
            self.screen:view('/')
        end
    else
        self.backTimer = 0
    end
end


function Level:draw()
    -- black bg
    love.graphics.clear(base.cBlack)

    -- stage
    love.graphics.setColor(base.cWhite)
    love.graphics.circle("line", base.guiWidth/2, base.guiHeight/2, base.guiHeight/2)
    --[[
    for i = 1, base.guiWidth, 10 do
        for j = 1, base.guiHeight, 10 do
            if base.getDis(base.guiWidth/2, base.guiHeight/2, i, j) > base.guiHeight/2 then
                love.graphics.points(i, j)
            end
        end
    end
    ]]

    -- fighter
    for i, fighter in ipairs(self.fighterList) do
        fighter:draw()
    end
    
    --ui
    love.graphics.setColor(base.cWhite)
    base.print('Up', base.guiBorder, base.guiHeight-base.guiBorder, 'left', 'bottom')
    base.print('Y', base.guiWidth-base.guiBorder, base.guiHeight-base.guiBorder, 'right', 'bottom')

    -- win
    if self.finish then
        local text = 'blue'
        if self.loserIndex == 1 then
            text = 'red'
        end

        love.graphics.setColor(base.cWhite)
        base.print(text .. ' win!', base.guiWidth/2, base.guiHeight/2, 'center', 'center')
    end
end


function Level:addFighterList(class, ...)
    table.insert(self.fighterList, class(...))
end