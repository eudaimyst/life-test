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

local sourceBlocks = {
    ["barren"] = {},
    ["lush"] = {},
    ["water"] = {}
}

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

local function setSourceBlocks()
    print("setting node Blocks")
    --set 10 random Blocks to water, barren earth and lush earth respectively
    local function setBlocks(colorType)
        for i = 1, 10 do
            local x = math.random(1, c.gridSize)
            local y = math.random(1, c.gridSize)
            --print(c.colors[colorType])
            print(x, y)
            grid[y][x]:setColor(c.colors[colorType], true)
            sourceBlocks[colorType][#sourceBlocks[colorType] + 1] = grid[x][y]
        end
    end
    setBlocks("water")
    setBlocks("barren")
    setBlocks("lush")
end

local function spreadBlockTypes()
    print("expanding nodes")
    --expand the water, barren earth and lush earth Blocks radially
    --for each block in the sourceBlocks, set the color of the block on each side (including diagonally) to the same as the source
    for i = 1, 10 do
        for k, v in pairs(sourceBlocks) do
            --check all the surrounding blocks of the source block to see if they are not black
            for _, block in pairs(v) do
                for _, side in pairs(c.sides) do
                    local x = block.x + side.x
                    local y = block.y + side.y
                    if x > 0 and x <= c.gridSize and y > 0 and y <= c.gridSize then
                        if grid[y][x]:getColor() == c.colors["black"] then
                            grid[y][x]:setColor(c.colors[k], true)
                            sourceBlocks[k][#sourceBlocks[k] + 1] = grid[y][x]
                        end
                    end
                end
            end
        end
    end
end

local function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generateBlocks()
        if not generating then
            print("done generating")
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
