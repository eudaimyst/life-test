local M = {}
local tickRate = 1000 -- in milliseconds
local lastTickTime = 0
local agentModule = require("modules.agent")

local agents = {}
M.agents = agents

-- Update function to process agent ticks
local function update(event)
    local currentTime = system.getTimer()
    local elapsedTime = currentTime - lastTickTime

    if elapsedTime >= tickRate then
        print("tick")
        for i = #agents, 1, -1 do
            local currentAgent = agents[i]
            if currentAgent.isDead then
                -- Remove dead agents
                table.remove(agents, i)
            else
                currentAgent:tick()
            end
        end
        lastTickTime = currentTime
    end
end

-- Start the simulation loop
M.BeginUpdate = function()
    -- Spawn 10 agents
    for i = 1, 10 do
        table.insert(agents, agentModule.Create())
    end
    lastTickTime = system.getTimer() -- Initialize the starting time
    Runtime:addEventListener("enterFrame", update)
end

-- Stop the simulation loop (optional)
M.EndUpdate = function()
    Runtime:removeEventListener("enterFrame", update)
end

return M
