-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- inspired by Max
-- I doubt I will get the time to finish this
-- one solwara
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
math.randomseed(os.time())
print("Hello World")
local function genComplete()
    print("Generation Complete")
    sim.BeginUpdate()
end
world.BeginGen(genComplete)
