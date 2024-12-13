local M = {}
local c = require("const")

function M.Create (x, y)

    local block = {}
    block.x = x
    block.y = y
    block.rect = display.newRect((x-1) * c.blockW, (y-1) * c.blockH, c.blockW, c.blockH)
    block.fillColor = {0, 0, 0}

    block.setColor = function (self, color)
        self.rect:setFillColor(unpack(color))
        self.fillColor = color
    end

    block.getColor = function (self)
        return self.fillColor
    end

    return block

end

return M