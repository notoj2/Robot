local Screen = Screen:extend()

function Screen:activate()
    self.img_gameLogo = love.graphics.newImage("img/gameLogo.png")
    self.menuText = {'CPU', 'PVP'}
    self.menuIndex = 1
end

function Screen:update(dt)
    -- menu
    if base.isPressed(keys.left) or base.isPressed(keys.right) then
        if self.menuIndex==1 then
            self.menuIndex = 2
        else
            self.menuIndex = 1
        end
    end

    -- enter
    if base.isPressed(keys.A) then
        if self.menuIndex == 1 then
            self.screen:view('pveScreen')
        else
            self.screen:view('pvpScreen')
        end
    end
end

function Screen:draw()
    -- black bg
    love.graphics.setColor(base.cBlack)
    love.graphics.rectangle("fill", 0, 0, base.guiWidth, base.guiHeight)

    love.graphics.setColor(base.cWhite)
    -- menu
    for i, text in ipairs(self.menuText) do
        if i==self.menuIndex then
            text = '> '..text..' <'
        end
        base.print(text, base.guiWidth/3*i, base.guiHeight/5*4, "center", "center")
    end

    base.print("A - Start\t\t<> - Select", base.guiWidth/2, base.guiHeight, "center", "bottom")

    -- img
    local scale1 = 0.9
    love.graphics.draw(self.img_gameLogo, base.guiWidth*(1-scale1)/2, 10, 0, scale1, scale1)
end


return Screen