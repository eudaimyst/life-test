local sim = require("modules.sim")
local M = {}

-- Display group to manage all UI elements
local uiGroup = display.newGroup()

-- Initialize the UI for each agent
local function drawAgentRect(agent, id)
    -- Draw background rectangle
    local uiRect = display.newRect(uiGroup, -200, 100 * id, 100, 80)
    uiRect:setFillColor(0.5, 0.5, 0.5)
    uiRect.strokeWidth = 2
    uiRect:setStrokeColor(1, 1, 1)

    -- Create text for agent stats
    local uiText =
        display.newText(
        {
            parent = uiGroup,
            text = "Loading...",
            x = -200,
            y = 100 * id,
            font = native.systemFont,
            fontSize = 12,
            align = "left"
        }
    )

    -- Assign uiText to the agent for easy updating later
    agent.uiText = uiText
end

-- Update the UI stats for all agents
local function updateUI()
    -- Check if agents exist
    if not sim.agents or #sim.agents == 0 then
        print("No agents to update.")
        return
    end

    -- Update each agent's stats display
    for i = 1, #sim.agents do
        local agent = sim.agents[i]
        if agent.uiText then
            agent.uiText.text =
                "Agent " ..
                i ..
                    "\nHealth: " ..
                        agent.health ..
                            "\nHunger: " .. agent.hunger .. "\nThirst: " .. agent.thirst .. "\nAge: " .. agent.age
        end
    end
end

-- Initialize the UI module
M.init = function()
    -- Clear previous UI elements, if any
    uiGroup:removeSelf()
    uiGroup = display.newGroup()

    -- Initialize UI for all agents
    if not sim.agents or #sim.agents == 0 then
        print("No agents to initialize.")
        return
    end

    for i = 1, #sim.agents do
        drawAgentRect(sim.agents[i], i)
    end

    -- Add the event listener to update stats every frame
    Runtime:addEventListener("enterFrame", updateUI)

    -- Print confirmation
    print("UI Module initialized")
end

-- Optional cleanup function
M.cleanup = function()
    -- Remove event listener
    Runtime:removeEventListener("enterFrame", updateUI)

    -- Clear the UI group
    if uiGroup then
        uiGroup:removeSelf()
        uiGroup = nil
    end

    print("UI Module cleaned up")
end

return M
