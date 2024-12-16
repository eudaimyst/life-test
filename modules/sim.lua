local M = {}
local tickRate = 1000 -- in milliseconds
local lastTickTime = 0

-- Update function
local function update(event)
    local currentTime = system.getTimer()
    local elapsedTime = currentTime - lastTickTime

    if elapsedTime >= tickRate then
        print("tick")
        lastTickTime = currentTime
    end
end

-- Start the update loop
M.BeginUpdate = function()
    lastTickTime = system.getTimer() -- Initialize the starting time
    Runtime:addEventListener("enterFrame", update)
end

-- Stop the update loop (optional)
M.EndUpdate = function()
    Runtime:removeEventListener("enterFrame", update)
end

return M
