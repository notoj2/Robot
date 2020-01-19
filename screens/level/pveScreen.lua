local Screen = Level:extend()


function Screen:activate(fighterIndex, fighterScore1, fighterScore2)
    Screen.super.activate(self, fighterIndex, fighterScore1, fighterScore2)

    local fighterC = {base.cPlayer1, base.cPlayer2}

    self:addFighterList(Player,     base.guiWidth/2, base.guiHeight/4*3, math.pi/2*3, fighterC[fighterIndex], fighterIndex)
    self:addFighterList(FighterAI,  base.guiWidth/2, base.guiHeight/4, math.pi/2, fighterC[3-fighterIndex], fighterIndex)
end


return Screen