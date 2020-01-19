local Screen = Level:extend()


function Screen:activate(fighterIndex, fighterScore1, fighterScore2)
    Screen.super.activate(self, fighterIndex, fighterScore1, fighterScore2)

    local fighterC = {base.cPlayer1, base.cPlayer2}
    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4*3,    math.pi/2*3,    fighterC[fighterIndex],     fighterIndex)
    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4,      math.pi/2,      fighterC[3-fighterIndex],   fighterIndex, keys.L, keys.R)

    --- canvas
    self.canvas = love.graphics.newCanvas()
    love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(base.cWhite)
        base.print('L', base.guiBorder, base.guiHeight-base.guiBorder, 'left', 'bottom')
        base.print('R', base.guiWidth-base.guiBorder, base.guiHeight-base.guiBorder, 'right', 'bottom')
    love.graphics.setCanvas()
    ---
end


function Screen:draw()
    Screen.super.draw(self)

    love.graphics.setColor(base.cWhite)
    love.graphics.draw(self.canvas, base.guiWidth, base.guiHeight, math.pi, 1, 1)
end


return Screen