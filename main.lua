-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- inspired by Max
-- I doubt I will get the time to finish this
-- one solwara
--
-----------------------------------------------------------------------------------------
-- this is a comment
-- log to the cosnole using solar2d
print("Hello World")
--create a grid of pixels, 10k by 10k
local grid = {}
local gridSize = 200
local pixelSize = 2
local deltaTime = 0
local oldTime = 0
local frameTime = 0
-- overide update function in solar 2d
local i, j = 1, 1

--solar2d update function

print('start')
local generating = true


function generatePixels()
    while (frameTime < 1000) and (i <= gridSize) do
        --print('ij', i, j)
        --get delta time using solar2d event
        frameTime = frameTime + deltaTime
        if j < gridSize then
           j = j + 1
           display.newRect(i*pixelSize, j*pixelSize, pixelSize, pixelSize )
        else 
            j = 1
            i = i + 1
        end
    end
    if i > gridSize then
        print('done')
    end
end

function update()
    deltaTime = system.getTimer() - oldTime
    if (generating) then
        generatePixels()
    end
    frameTime = 0
    oldTime = system.getTimer()
end

Runtime:addEventListener( "enterFrame", update )
-- Your code here