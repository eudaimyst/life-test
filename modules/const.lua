local M = {}
M.gridSize = 100
M.blockSize = 6
M.blockW, M.blockH = M.blockSize, M.blockSize --temp will scale to screen size

M.colors = {}

M.colors = {
    ["barren"] = {139 / 255, 69 / 255, 19 / 255},
    ["lush"] = {50 / 255, 205 / 255, 50 / 255},
    ["water"] = {30 / 255, 144 / 255, 255 / 255},
    ["black"] = {.1, .1, .1}
}

M.sides = {
    ["t"] = {["x"] = 0, ["y"] = -1},
    ["b"] = {["x"] = 0, ["y"] = 1},
    ["l"] = {["x"] = -1, ["y"] = 0},
    ["r"] = {["x"] = 1, ["y"] = 0},
    ["tl"] = {["x"] = -1, ["y"] = -1},
    ["tr"] = {["x"] = 1, ["y"] = -1},
    ["bl"] = {["x"] = -1, ["y"] = 1},
    ["br"] = {["x"] = 1, ["y"] = 1}
}

return M
