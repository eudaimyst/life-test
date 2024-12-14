local M = {}
local c = require("const")

function M.Create(y, x)
    local block = {}
    block.x = x
    block.y = y
    block.hasBeenSpread = false
    block.rect = display.newRect(x * c.blockW, y * c.blockH, c.blockW, c.blockH)
    block.fillColor = {0, 0, 0}
    block.neighbours = {}
    --for each side of the block, add the block to the neighbours table
    for k, _ in pairs(c.sides) do
        block.neighbours[k] = {}
    end

    block.setColor = function(self, color, drawText)
        self.rect:setFillColor(unpack(color))
        self.fillColor = color
        if drawText then
            block.debugText =
                display.newText(
                ((self.x) .. ", " .. (self.y)),
                (x - 1) * c.blockW,
                (y - 1) * c.blockH,
                native.systemFont,
                10
            )
        end
    end

    block.getColor = function(self)
        return self.fillColor
    end

    return block
end

return M
