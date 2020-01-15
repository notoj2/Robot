local Screen = Level:extend()


function Screen:activate()
    Screen.super.activate(self)

    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4*3, math.pi/2*3, base.cPlayer2)
    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4, math.pi/2, base.cPlayer1, keys.L, keys.R)

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