local gsKeys = {}
local keys = {}

-- GAMESHELL. See here: https://github.com/clockworkpi/Keypad/blob/master/keymaps.png
-- A, B, X, Y
gsKeys.Y = 'i'
gsKeys.X = 'u'
gsKeys.A = 'j'
gsKeys.B = 'k'
-- D-Pad
gsKeys.DPad_up =	'up'
gsKeys.DPad_down =	'down'
gsKeys.DPad_right =	'right'
gsKeys.DPad_left =	'left'
-- Special Keys
gsKeys.Start =		'return'
gsKeys.Select =		'space'
gsKeys.Volume_down ='kp-'
gsKeys.Volume_up =	'kp+'
-- Menu
gsKeys.Menu = 'escape'
-- Lightkey
gsKeys.LK1 = 'h'
gsKeys.LK2 = 'y'
--keys.LK3 = keys.lk3 = ''  <-- Not usable, is shift
gsKeys.LK4 = 'o'
gsKeys.LK5 = 'l'
gsKeys.LK1_shift = 'home'
gsKeys.LK2_shift = 'pageup'
--keys.LK3_shift = lk3_shift = ''  <-- Still not usable...
gsKeys.LK4_shift = 'pagedown'
gsKeys.LK5_shift = 'end'


-- all key
local function keyCreater(keyboard, gamepad)
    local table = {}

    table.keyboard = keyboard
    table.gamepad = gamepad
    -- set default released
    table.isPressed = false
    table.released = false
    table.timer = 0
    table.timerMax = 0

    return table
end

keys.up     = keyCreater(gsKeys.DPad_up,      "dpup")
keys.down   = keyCreater(gsKeys.DPad_down,    "dpdown")
keys.left   = keyCreater(gsKeys.DPad_left,    "dpleft")
keys.right  = keyCreater(gsKeys.DPad_right,  "dpright")
keys.Y      = keyCreater(gsKeys.Y,           "y")
keys.A      = keyCreater(gsKeys.A,           "a")
keys.B      = keyCreater(gsKeys.B,           "b")
keys.X      = keyCreater(gsKeys.X,           "x")
keys.select = keyCreater(gsKeys.Select,      "back")
keys.start  = keyCreater(gsKeys.Start,       "start")
keys.L      = keyCreater(gsKeys.LK1,       "leftshoulder")
keys.R      = keyCreater(gsKeys.LK5,       "rightshoulder")

return keys