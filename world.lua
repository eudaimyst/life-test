local M = {
}

local grid = {}
local gridSize = 200
local pixelSize = 2
local deltaTime = 0
local oldTime = 0
local frameTime = 0
-- overide update function in solar 2d
local i, j = 1, 1

local barrenEarth = {139/255, 69/255, 19/255}
local lushEarth = {50/255, 205/255, 50/255}
local water = {30/255, 144/255, 255/255}

print('start')
local generating = true

local function generatePixels()
    while (frameTime < 1000) and (i <= gridSize) do
        --print('ij', i, j)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        if j < gridSize then
           j = j + 1
           if grid[i] == nil then
                grid[i] = {}
            end
           grid[i][j] = display.newRect(i*pixelSize, j*pixelSize, pixelSize, pixelSize )
        else 
            j = 1
            i = i + 1
        end
    end
    if i > gridSize then
        generating=false
    end
end

local function setPixelTypes()
    --set 10 random pixels to water, barren earth and lush earth respectively
    local function setPixels(colorType)
        for i = 1, 10 do
            local x = math.random(1, gridSize)
            local y = math.random(1, gridSize)
            grid[x][y]:setFillColor(unpack(colorType))
        end
    end
    setPixels(water)
    setPixels(barrenEarth)
    setPixels(lushEarth)
end

local function expandPixelTypes()
    --expand the water, barren earth and lush earth pixels
    local function expandPixels(colorType)
        for i = 1, gridSize do
            for j = 1, gridSize do
                if grid[i][j] == colorType then
                    --expand the pixel
                    if i > 1 then
                        grid[i-1][j] = colorType
                    end
                    if i < gridSize then
                        grid[i+1][j] = colorType
                    end
                    if j > 1 then
                        grid[i][j-1] = colorType
                    end
                    if j < gridSize then
                        grid[i][j+1] = colorType
                    end
                end
            end
        end
    end
    expandPixels(water)
    expandPixels(barrenEarth)
    expandPixels(lushEarth)

end

local function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generatePixels()
        if not generating then
            print('done generating')
            setPixelTypes()
        end
    end
    frameTime = 0
    oldTime = system.getTimer()
end

function M.beginGen() 
    Runtime:addEventListener( "enterFrame", update )
end

return M