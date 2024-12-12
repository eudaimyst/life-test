-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- inspired by Max
-- I doubt I will get the time to finish this
--
-----------------------------------------------------------------------------------------
-- this is a comment
-- log to the cosnole using solar2d
print("Hello World")
--create a grid of pixels, 10k by 10k
local grid = {}
local gridSize = 500
local deltaTime = 0
local oldTime = 0
local frameTime = 0
-- overide update function in solar 2d
local i, j = 1, 1

--solar2d update function

function update()

-- Your code here
    --get current time in ms
    -- add pixels to the grid
    print(frameTime)
    while frameTime < 500 do
        if j < gridSize then
            deltaTime = oldTime - system.getTimer()
            frameTime = frameTime + deltaTime
            print('startloop')
            i = i + 1
            grid[i] = {}
            if i > gridSize then
                i = 1
                j = j + 1
                grid[i][j] =display.newRect(i, j, 1, 1)
            end
        end
    end
    frameTime = 0
    oldTime = time
end

Runtime:addEventListener( "enterFrame", update )
-- Your code here