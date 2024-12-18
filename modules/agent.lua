local M = {}
local c = require("modules.const")
local world = require("modules.world")

-- Utility function to calculate Euclidean distance
local function calculateDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- Create a new agent
M.Create = function()
    local agent = {}

    -- Agent position and visual representation
    agent.x = math.random(1, c.gridSize)
    agent.y = math.random(1, c.gridSize)
    agent.rect = display.newRect(agent.x * c.blockSize, agent.y * c.blockSize, c.blockSize, c.blockSize)
    agent.rect:setFillColor(1, 1, 1)

    -- Agent stats
    agent.health = 100
    agent.hunger = 0
    agent.thirst = 0
    agent.age = 0

    -- Agent behavior logic
    function agent:move()
        local targetX, targetY = 0, 0
        local shortestDistance = math.huge

        if self.hunger > 50 then
            -- Find nearest lush block
            for i = 1, c.gridSize do
                for j = 1, c.gridSize do
                    if world.grid[i][j].color == c.colors["lush"] then
                        local distance = calculateDistance(self.x, self.y, i, j)
                        if distance < shortestDistance then
                            shortestDistance = distance
                            targetX = i - self.x
                            targetY = j - self.y
                        end
                    end
                end
            end
        elseif self.thirst > 50 then
            -- Find nearest water block
            for i = 1, c.gridSize do
                for j = 1, c.gridSize do
                    if world.grid[i][j].color == c.colors["water"] then
                        local distance = calculateDistance(self.x, self.y, i, j)
                        if distance < shortestDistance then
                            shortestDistance = distance
                            targetX = i - self.x
                            targetY = j - self.y
                        end
                    end
                end
            end
        else
            -- Random movement
            targetX = math.random(-1, 1)
            targetY = math.random(-1, 1)
        end

        -- Keep the agent within grid bounds
        if self.x + targetX < 1 or self.x + targetX > c.gridSize then
            targetX = 0
        end
        if self.y + targetY < 1 or self.y + targetY > c.gridSize then
            targetY = 0
        end

        -- Update agent position
        self.x = self.x + targetX
        self.y = self.y + targetY
        self.rect.x = self.x * c.blockSize
        self.rect.y = self.y * c.blockSize
    end

    function agent:updateStats()
        -- Update stats based on current block color
        local currentBlockColor = world.grid[self.x][self.y]:getColor()

        if currentBlockColor == c.colors["lush"] then
            self.hunger = math.max(0, self.hunger - 5)
            self.thirst = math.min(100, self.thirst + 5)
        elseif currentBlockColor == c.colors["water"] then
            self.thirst = math.max(0, self.thirst - 5)
            self.hunger = math.min(100, self.hunger + 5)
        elseif currentBlockColor == c.colors["barren"] then
            self.hunger = math.min(100, self.hunger + 5)
            self.thirst = math.min(100, self.thirst + 5)
        end
        print("Agent Stats Updated - Hunger:", self.hunger, "Thirst:", self.thirst, "Health:", self.health)

        -- Decrease health if hunger or thirst exceeds 80
        if self.hunger > 80 or self.thirst > 80 then
            self.health = self.health - 5
        end

        -- Check for death
        if self.health <= 0 then
            self:die()
        end
    end

    function agent:die()
        -- Remove visual representation and mark the agent as dead
        if self.rect then
            self.rect:removeSelf()
            self.rect = nil
        end
        self.isDead = true
        print("Agent died")
    end

    -- Agent's main tick function
    function agent:tick()
        if self.isDead then
            return
        end

        -- Perform movement and stat updates
        self:move()
        self:updateStats()
        self.age = self.age + 1

        -- Update UI text to reflect new stats
        if self.uiText then
            self.uiText.text =
                "Agent\n" ..
                "Health: " ..
                    self.health ..
                        "\n" ..
                            "Hunger: " ..
                                self.hunger .. "\n" .. "Thirst: " .. self.thirst .. "\n" .. "Age: " .. self.age
        end
    end

    return agent
end

return M
