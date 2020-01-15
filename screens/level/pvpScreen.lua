local Screen = Level:extend()


function Screen:activate()
    Screen.super.activate(self)

    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4*3, math.pi/2*3, base.cPlayer2)
    self:addFighterList(Player, base.guiWidth/2, base.guiHeight/4, math.pi/2, base.cPlayer1, keys.L, keys.R)

    
end




return Screen