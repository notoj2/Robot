--- LOADING SCREEN
love.graphics.clear(0, 0, 0)
local img = love.graphics.newImage("img/loading.png")
love.graphics.draw(img)
love.graphics.present()


--- LIB
-- font
local font = love.graphics.newFont("font/iosevka-bold.ttf", 20)
love.graphics.setFont(font)
-- object-oriented
Object = require "lib.classic"
-- base
base = require "lib.base"
keys = require "lib.keys"
require "lib.screen"
require "lib.level"
require "lib.fighter"
require "lib.player"
require "lib.fighterAI"
-- screenManager
local ScreenManager = require "lib.screenManager"

--- LOAD SCREENS
local MainScreen = require "screens.mainScreen"
local pvpScreen = require "screens.level.pvpScreen"
local pveScreen = require "screens.level.pveScreen"

--- LOAD GAME
function love.load()
    
     --- register screens
    local screenManager = ScreenManager()
    screenManager:register('/', MainScreen)   -- frist
    screenManager:register('pvpScreen', pvpScreen)
    screenManager:register('pveScreen', pveScreen)
end