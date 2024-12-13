local M = {}

local grid = {}
local gridSize = 100
local blockSize = 6
local deltaTime = 0
local oldTime = 0
local frameTime = 0
-- overide update function in solar 2d
local i, j = 1, 1

local barrenEarth = {139 / 255, 69 / 255, 19 / 255}
local lushEarth = {50 / 255, 205 / 255, 50 / 255}
local water = {30 / 255, 144 / 255, 255 / 255}
local black = {.1, .1, .1}

print("start")
local generating = true

local function generateBlocks()
    while (frameTime < 1000) and (i <= gridSize) do
        --print('ij', i, j)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        if j <= gridSize then
            j = j + 1
            if grid[i] == nil then
                grid[i] = {}
            end
            grid[i][j] = display.newRect(i * blockSize, j * blockSize, blockSize, blockSize)
            grid[i][j]:setFillColor(unpack(black))
            grid[x][y].fillColor = unpack(black)
        else
            j = 1
            i = i + 1
        end
    end
    if i > gridSize then
        generating = false
    end
end

local function setBlockTypes()
    print("setting node Blocks")
    --set 10 random Blocks to water, barren earth and lush earth respectively
    local function setBlocks(colorType)
        for i = 1, 10 do
            local x = math.random(1, gridSize)
            local y = math.random(1, gridSize)
            grid[x][y]:setFillColor(unpack(colorType))
            grid[x][y].fillColor = unpack(colorType)
        end
    end
    setBlocks(water)
    setBlocks(barrenEarth)
    setBlocks(lushEarth)
end

local function expandBlockTypes()
    print("expanding nodes")
    --expand the water, barren earth and lush earth Blocks
    local function expandBlocks(colorType)
        for i = 1, gridSize do
            for j = 1, gridSize do
                if grid[i][j].fillColor == colorType then
                    if i > 1 then
                        grid[i - 1][j]:setFillColor(unpack(colorType))
                    end
                    if i < gridSize then
                        grid[i + 1][j]:setFillColor(unpack(colorType))
                    end
                    if j > 1 then
                        grid[i][j - 1]:setFillColor(unpack(colorType))
                    end
                    if j < gridSize then
                        grid[i][j + 1]:setFillColor(unpack(colorType))
                    end
                end
            end
        end
    end
    expandBlocks(water)
    expandBlocks(barrenEarth)
    expandBlocks(lushEarth)
end

local function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generateBlocks()
        if not generating then
            print("done generating")
            setBlockTypes()
            expandBlockTypes()
        end
    end
    frameTime = 0
    oldTime = system.getTimer()
end

function M.beginGen()
    Runtime:addEventListener("enterFrame", update)
end

return M
