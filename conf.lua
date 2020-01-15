function love.conf(t)
    t.window.title = "Metal Fighter"
    t.window.width = 320
    t.window.height = 240

    t.modules.mouse = false
    t.modules.touch = false

    t.accelerometerjoystick = false     -- false, because Gameshell doesn't have a accelerometer
end