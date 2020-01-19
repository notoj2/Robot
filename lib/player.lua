Player = Fighter:extend()


function Player:new(x, y, dir, cLine, id, leftKey, rightKey)
    Player.super.new(self, x, y, dir, cLine, id)

    self.leftKey = keys.up
    if leftKey ~= nil then
        self.leftKey = leftKey
    end
    
    self.rightKey = keys.Y
    if rightKey ~= nil then
        self.rightKey = rightKey
    end
end


function Player:update(dt, fighterList)
    Player.super.update(self, dt, base.isPressed(self.leftKey), base.isPressed(self.rightKey), fighterList)
end