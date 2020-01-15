-- base on https://github.com/Skayo/Gameshell-Love2D-Template, change a little bit
local ScreenManager = Object:extend()

function ScreenManager:new()
	self.routes = {}
	self.currentScreen = nil
	self.currentPath = ''
	
	self:registerEvents()
end

function ScreenManager:event(event, arguments)
	if arguments == nil then
		arguments = {}
	elseif type(arguments) ~= 'table' then
		arguments = {arguments}
	end
	
	if self.activeScreen and self.activeScreen[event] then
		self.activeScreen[event](--[[self=]] self.activeScreen, unpack(arguments))
	end
end

function ScreenManager:register(path, screenClass)
	local newRoute = {
		path = path,
		instance = screenClass(self)
	}
	
	if path == '/' then -- if screen is the root path then register it by default
		newRoute.instance:activate()
		self.activeScreen = newRoute.instance
		self.currentPath = '/'
	end
	
	return table.insert(self.routes, newRoute)
end

function ScreenManager:view(path, ...)
	for _, route in pairs(self.routes) do
		if path == route.path then
			route.instance:activate(...)
			self.activeScreen = route.instance
			self.currentPath = path
		end
	end

	-- for reset level
	resetLevelString = path
end

-- Register Löve2D events
function ScreenManager:registerEvents()
	local _self = self
	
	-- Only the ones that could be used on a gameshell are not commented out!
	-- The events that are commented out with four '-', cause trouble when not being used
	
	--function love.directorydropped(...) _self:event('directorydropped', ...) end
	function love.draw(...)	_self:event('draw', ...) end
	----function love.errhand(...) _self:event('errhand', ...) end
	----function love.errorhandler(...) _self:event('errorhandler', ...) end
	--function love.filedropped(...) _self:event('filedropped', ...) end
	function love.focus(...) _self:event('focus', ...) end
	function love.keypressed(...)
		if select(1, ...) == 'escape' then
			love.event.quit()
		end
		
		--- [debug] f1, run the file in screens/debug
		if debugMode and select(1, ...) == 'f1' then
			local fileTable = love.filesystem.getDirectoryItems("screens/debug")
			local fileName
			for key, value in pairs(fileTable) do
				fileName = value
			end
			if fileName ~= nil then
				lang = require("lib.lang.lang_cn")
				
				local levelName = string.sub(fileName, 1, string.len(fileName)-string.len(".lua"))
				self:register(levelName, require("screens.debug." .. levelName))
				self:view(levelName)
				print("debug: goto " .. levelName)
			else
				print("debug: file don't exist.")
			end
		end
		---

		_self:event('keypressed', ...)
	end
	function love.keyreleased(...) _self:event('keyreleased', ...) end
	function love.lowmemory(...) _self:event('lowmemory', ...) end
	--function love.mousefocus(...) _self:event('mousefocus', ...) end
	--function love.mousemoved(...) _self:event('mousemoved', ...) end
	--function love.mousepressed(...) _self:event('mousepressed', ...) end
	--function love.mousereleased(...) _self:event('mousereleased', ...) end
	function love.quit(...) _self:event('quit', ...) end
	function love.resize(...) _self:event('resize', ...) end
	----function love.run(...) _self:event('run', ...) end
	function love.textedited(...) _self:event('textedited', ...) end
	function love.textinput(...) _self:event('textinput', ...) end
	function love.threaderror(...) _self:event('threaderror', ...) end
	--function love.touchmoved(...) _self:event('touchmoved', ...) end
	--function love.touchpressed(...) _self:event('touchpressed', ...) end
	--function love.touchreleased(...) _self:event('touchreleased', ...) end
	function love.update(...)
		-- limit FPS
		local t = {...}
		local dt = t[1]
		local maxFPS = 60
		if dt < 1/maxFPS then
			love.timer.sleep(1/maxFPS - dt)
		end

		-- pressed Setting
		keys = base.pressedSetting(keys, dt)

		_self:event('update', ...)
	end
	function love.visible(...) _self:event('visible', ...) end
	--function love.wheelmoved(...) _self:event('wheelmoved', ...) end
end

return ScreenManager