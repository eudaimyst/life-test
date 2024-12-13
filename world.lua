local M = {}
local c = require("const")
local block = require("block")

local grid = {}
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
assignedBlockCount = 0

local function updateAssignedBlockCount()
    --for each source block, increment the assignedBlockCount
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
                    grid[i][j].neighbours[sideKey][1] = grid[y][x]
                --print("seting neighbour for ", i, j)
                --print("for sidekey", sideKey, "to", x, y)
                end
            end
        end
    end
    print("done setting neighbours")
end

local function setBlockType(block, blockType)
    block:setColor(c.colors[blockType], false)
    sourceBlocks[blockType][#sourceBlocks[blockType] + 1] = block
end

local function setSourceBlocks()
    print("setting node Blocks")
    --set 10 random Blocks to water, barren earth and lush earth respectively
    local function setBlocks(colorType)
        for i = 1, 10 do
            local x = math.random(1, c.gridSize)
            local y = math.random(1, c.gridSize)
            --print(c.colors[colorType])
            print(x, y)
            setBlockType(grid[x][y], colorType)
            --grid[y][x]:setColor(c.colors[colorType], true)
            --sourceBlocks[colorType][#sourceBlocks[colorType] + 1] = grid[x][y]
        end
    end
    setBlocks("water")
    setBlocks("barren")
    setBlocks("lush")
end

local function spreadBlockTypes()
    print("expanding nodes")
    --pick a random source block

    while (frameTime < 1000 and assignedBlockCount <= (c.gridSize * c.gridSize)) do
        updateAssignedBlockCount()
        print("assignedBlockCount", assignedBlockCount)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        --pick a random source block type, spread to the neighbours of a random source block
        local sourceBlockType = sourceBlockTypes[math.random(1, 3)]
        local sourceBlock = sourceBlocks[sourceBlockType][math.random(1, #sourceBlocks[sourceBlockType])]
        local sourceBlockNeighbours = sourceBlock.neighbours
        --set the block type of the neighbours of the source block
        for sideKey, side in pairs(c.sides) do
            local neighbour = sourceBlockNeighbours[sideKey][1]
            if neighbour ~= nil then
                local neighbourColor = neighbour:getColor()
                if neighbourColor == c.colors["black"] then
                    setBlockType(neighbour, sourceBlockType)
                end
            end
        end
    end
    if assignedBlockCount >= (c.gridSize * c.gridSize) then
        spreading = false
    end
end

local function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generateBlocks()
        if not generating then
            print("done generating")
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

function M.BeginGen()
    Runtime:addEventListener("enterFrame", update)
end

return M
