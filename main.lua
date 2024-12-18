-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- inspired by Max
--
-- built with Solar2D
-- credit: chatGPT, Github Copilot
--
-----------------------------------------------------------------------------------------
-- this is a comment
-- log to the cosnole using solar2d

--import world module
local world = require("modules.world")
local sim = require("modules.sim")
local ui = require("modules.ui")
--initialize the ui
math.randomseed(os.time())
print("Hello World")
local function genComplete()
    print("Generation Complete")
    sim.BeginUpdate()
    ui.init()
end
world.BeginGen(genComplete)
