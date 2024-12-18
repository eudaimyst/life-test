local M = {}
local json = require "json"
local c = require("modules.const")
local block = require("modules.block")

local genCompleteCallback = nil

local grid = {}
M.grid = grid
local deltaTime = 0
local oldTime = 0
local frameTime = 0
-- overide update function in solar 2d
local i, j = 1, 1

local barrenEarth = {139 / 255, 69 / 255, 19 / 255}
local lushEarth = {50 / 255, 205 / 255, 50 / 255}
local water = {30 / 255, 144 / 255, 255 / 255}
local black = {.1, .1, .1}

local sourceBlockTypes = {"barren", "lush", "water"}
local sourceBlocks = {
    ["barren"] = {},
    ["lush"] = {},
    ["water"] = {}
}
local spreadTypeCount = 1 --for iterating the block types when spreading
local spreadCount = {
    --for iterating through the sourceBlocks
    ["barren"] = 1,
    ["lush"] = 1,
    ["water"] = 1
}
assignedBlockCount = 0

local function updateAssignedBlockCount()
    --for each source block, increment the assignedBlockCount
    assignedBlockCount = 0
    for _, sourceBlockType in pairs(sourceBlocks) do
        assignedBlockCount = assignedBlockCount + #sourceBlockType
    end
end

print("start")
local generating = true
local spreading = false

local function generateBlocks()
    while (frameTime < 1000) and (i <= c.gridSize) do
        --print('ij', i, j)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        if j <= c.gridSize then
            if grid[i] == nil then
                grid[i] = {}
            end
            grid[i][j] = block.Create(i, j)
            grid[i][j]:setColor(c.colors["black"])
            j = j + 1
        else
            j = 1
            i = i + 1
        end
    end
    if i > c.gridSize then
        generating = false
    end
end

local function setNeighbours()
    for i = 1, c.gridSize do
        for j = 1, c.gridSize do
            for sideKey, side in pairs(c.sides) do
                local x = i + side.x
                local y = j + side.y
                if x > 0 and x <= c.gridSize and y > 0 and y <= c.gridSize then
                    grid[i][j].neighbours[sideKey][1] = grid[x][y]
                --print("seting neighbour for ", i, j)
                --print("for sidekey", sideKey, "to", x, y)
                end
            end
        end
    end
    print("done setting neighbours")
end

local function setBlockType(block, blockType, debugpos)
    block:setColor(c.colors[blockType], debugpos)
    sourceBlocks[blockType][#sourceBlocks[blockType] + 1] = block
end

local function setSourceBlocks()
    print("setting node Blocks")
    --set 10 random Blocks to water, barren earth and lush earth respectively
    local function setBlocks(colorType)
        for i = 1, 10 do
            local x = math.floor(math.random(100, c.gridSize * 100) / 100)
            local y = math.floor(math.random(100, c.gridSize * 100) / 100)
            --print(c.colors[colorType])
            print(x, y)
            setBlockType(grid[x][y], colorType, true)
            --grid[y][x]:setColor(c.colors[colorType], true)
            --sourceBlocks[colorType][#sourceBlocks[colorType] + 1] = grid[x][y]
        end
    end
    setBlocks("water")
    setBlocks("barren")
    setBlocks("lush")
end

local function spreadBlockTypes()
    --print("expanding nodes")
    --pick a random source block

    while (frameTime < 1000 and assignedBlockCount <= (c.gridSize * c.gridSize)) do
        updateAssignedBlockCount()
        --print("assignedBlockCount", assignedBlockCount)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        --pick a random source block type, spread to the neighbours of a random source block
        local sourceBlockType = sourceBlockTypes[spreadTypeCount]
        --print(sourceBlockType, spreadCount[sourceBlockType])

        local count = spreadCount[sourceBlockType]
        local sourceList = sourceBlocks[sourceBlockType]

        -- Ensure sourceBlocks[sourceBlockType] is not nil or empty
        if not sourceList or #sourceList == 0 then
            print("Error: No blocks available for type", sourceBlockType)
            return
        end

        -- Ensure count is within bounds
        if count > #sourceList then
            print("Error: spreadCount out of bounds for type", sourceBlockType)
            spreadCount[sourceBlockType] = 1 -- Reset to 1 or handle appropriately
            count = 1
        end

        -- Access the source block
        local sourceBlock = sourceList[count]
        if not sourceBlock then
            print("Error: sourceBlock is nil despite checks")
        else
            --print("Successfully accessed sourceBlock:", sourceBlock)
        end

        local sourceBlockNeighbours = sourceBlock.neighbours
        --set the block type of the neighbours of the source block
        if (not sourceBlock.hasBeenSpread) then
            --print("source block has been spread")
            for sideKey, side in pairs(c.sides) do
                local neighbour = sourceBlockNeighbours[sideKey][1]
                if neighbour ~= nil then
                    local neighbourColor = neighbour:getColor()
                    if neighbourColor == c.colors["black"] then
                        setBlockType(neighbour, sourceBlockType)
                    end
                end
                sourceBlock.hasBeenSpread = true
            end
        end
        spreadCount[sourceBlockType] = spreadCount[sourceBlockType] + 1
        spreadTypeCount = spreadTypeCount + 1
        if spreadTypeCount > 3 then
            spreadTypeCount = 1
        end
    end
    if assignedBlockCount >= (c.gridSize * c.gridSize) then
        spreading = false
        print("spreading complete")
        if genCompleteCallback then
            Runtime:removeEventListener("enterFrame", update)
            genCompleteCallback()
        end
    end
end

local function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generateBlocks()
        if not generating then
            print("done generating")
            --remove event listener
            setNeighbours()
            setSourceBlocks()
            spreading = true
        end
    end
    if (spreading) then
        spreadBlockTypes()
    end
    frameTime = 0
    oldTime = system.getTimer()
end

function M.BeginGen(callback)
    Runtime:addEventListener("enterFrame", update)
    genCompleteCallback = callback
end

return M
