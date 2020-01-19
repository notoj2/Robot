local Screen = Screen:extend()

function Screen:activate()
    self.img_gameLogo = love.graphics.newImage("img/gameLogo.png")
    self.menuText = {'CPU', 'PVP'}
    self.menuIndex = 1
    self.selectFighter = false
    self.selectFighterIndex = 1
    self.selectFighterText = {'Red', 'Blue'}
    self.selectFighterC = {base.cPlayer1, base.cPlayer2}
end

function Screen:update(dt)
    -- left and right
    if base.isPressed(keys.left) or base.isPressed(keys.right) then
        if not self.selectFighter then
            -- menu
            self.menuIndex = 3-self.menuIndex
        else
            -- selectFighter
            self.selectFighterIndex = 3 - self.selectFighterIndex
        end

        -- sfx
        sfx_menu:play()
    end

    -- enter
    if base.isPressed(keys.A) then
        if not self.selectFighter then
            -- selectFighter
            self.selectFighter = true
        else
            -- go
            if self.menuIndex == 1 then
                self.screen:view('pveScreen', self.selectFighterIndex, 0, 0)
            else
                self.screen:view('pvpScreen', self.selectFighterIndex, 0, 0)
            end
        end

        -- sfx
        sfx_menu:play()
    end

    -- back to menu
    if base.isPressed(keys.B) and self.selectFighter then
        self.selectFighter = false

        -- sfx
        sfx_menu:play()
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
    -- keys tips
    base.print("A - Start\t\t←→ - Select", base.guiWidth/2, base.guiHeight-base.guiBorder, "center", "bottom")

    -- img
    local scale1 = 0.9
    love.graphics.draw(self.img_gameLogo, base.guiWidth*(1-scale1)/2, 10, 0, scale1, scale1)

    -- selectFighter
    if self.selectFighter then
        -- bg
        love.graphics.setColor(base.cBlack[1], base.cBlack[2], base.cBlack[3], 0.85)
        love.graphics.rectangle("fill", 0, 0, base.guiWidth, base.guiHeight)
        -- text
        love.graphics.setColor(base.cWhite)
        base.print(self.menuText[self.menuIndex]..' - Select Fighter', base.guiWidth/2, base.guiHeight, "center", "bottom")
        -- selectFighter
        for i = 0, 1 do
            local offsetX = base.guiWidth/2
            -- text
            love.graphics.setColor(self.selectFighterC[i+1])
            base.print(self.selectFighterText[i+1], base.guiWidth/4+offsetX*i, (base.guiHeight-base.guiBorder*3)/2, 'center', 'center')

            -- box
            love.graphics.setColor(base.cDarkGray)            
            if i+1==self.selectFighterIndex then
                love.graphics.setColor(base.cWhite)
            end
            love.graphics.rectangle("line", base.guiBorder+offsetX*i, base.guiBorder, base.guiWidth/2-base.guiBorder*2, base.guiHeight-base.guiBorder*4)
        end
    end
end


return Screen