Level = Screen:extend()

function Level:activate(fighterIndex, fighterScore1, fighterScore2)
    self.fighterList = {}
    
    self.finish = false
    self.loserIndex = 0

    self.backTimer = 0
    self.backTimerMax = 60

    self.fighterIndex = fighterIndex

    self.fighterScoreList = {fighterScore1, fighterScore2}
    self.roundMax = 3
end


function Level:update(dt)
    for i, fighter in ipairs(self.fighterList) do
        if not self.finish then
            -- remove itself
            local _list = {}
            _list = base.tableClone(self.fighterList)
            table.remove(_list, i)

            -- update
            fighter:update(dt, _list)
            
            -- win -- 1 frame
            if not base.getCollisionCircle(fighter.x, fighter.y, fighter.radius, base.guiWidth/2, base.guiHeight/2, base.guiHeight/2) then
                self.finish = true
                self.loserIndex = fighter.id

                -- score++
                self.fighterScoreList[3-self.loserIndex] = self.fighterScoreList[3-self.loserIndex] + 1

                -- sfx
                sfx_finish:play()
            end
        end
    end

    -- finish
    if self.finish then
        if base.isPressed(keys.A) then
            if self.fighterScoreList[1]+self.fighterScoreList[2] >= self.roundMax then
                -- go mainScreen
                self.screen:view('/')
            else
                -- next round
                self:activate(self.fighterIndex, self.fighterScoreList[1], self.fighterScoreList[2])
            end
            
        end
    else
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
end


function Level:draw()
    -- black bg
    love.graphics.clear(base.cBlack)

    -- stage
    love.graphics.setColor(base.cWhite)
    love.graphics.circle("line", base.guiWidth/2, base.guiHeight/2, base.guiHeight/2)

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
        local textList = {'Red', 'Blue'}
        local scoreText = textList[self.fighterIndex] ..'\t'.. self.fighterScoreList[self.fighterIndex] .. ':' .. self.fighterScoreList[3-self.fighterIndex] ..'\t'.. textList[3-self.fighterIndex]

        love.graphics.setColor(base.cWhite)
        base.print(scoreText .. '\n\nA - Continue', base.guiWidth/2, base.guiHeight/2, 'center', 'center')
    end
end


function Level:addFighterList(class, ...)
    table.insert(self.fighterList, class(...))
end