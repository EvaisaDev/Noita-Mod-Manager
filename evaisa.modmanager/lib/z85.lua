-- Encode string using the following characters "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#" in Lua5.1
-- use the bit library
local chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#"
local bit = require("bit")

local function encode(input)
    local output = ""
    local i = 1
    local len = #input
    while i <= len do
        local c = string.byte(input, i)
        local c1 = bit.band(c, 0x0F)
        local c2 = bit.band(bit.rshift(c, 4), 0x0F)
        local c3 = bit.band(bit.rshift(c, 8), 0x0F)
        local c4 = bit.band(bit.rshift(c, 12), 0x0F)
        local c5 = bit.band(bit.rshift(c, 16), 0x0F)
        local c6 = bit.band(bit.rshift(c, 20), 0x0F)
        local c7 = bit.band(bit.rshift(c, 24), 0x0F)
        local c8 = bit.band(bit.rshift(c, 28), 0x0F)
        output = output .. string.sub(chars, c1 + 1, c1 + 1) .. string.sub(chars, c2 + 1, c2 + 1) .. string.sub(chars, c3 + 1, c3 + 1) .. string.sub(chars, c4 + 1, c4 + 1) .. string.sub(chars, c5 + 1, c5 + 1) .. string.sub(chars, c6 + 1, c6 + 1) .. string.sub(chars, c7 + 1, c7 + 1) .. string.sub(chars, c8 + 1, c8 + 1)
        i = i + 1
    end
    return output
end

local function decode(input)
    local output = ""
    local i = 1
    local len = #input
    while i <= len do
        local c1 = string.find(chars, string.sub(input, i, i), 1, true) - 1
        local c2 = string.find(chars, string.sub(input, i + 1, i + 1), 1, true) - 1
        local c3 = string.find(chars, string.sub(input, i + 2, i + 2), 1, true) - 1
        local c4 = string.find(chars, string.sub(input, i + 3, i + 3), 1, true) - 1
        local c5 = string.find(chars, string.sub(input, i + 4, i + 4), 1, true) - 1
        local c6 = string.find(chars, string.sub(input, i + 5, i + 5), 1, true) - 1
        local c7 = string.find(chars, string.sub(input, i + 6, i + 6), 1, true) - 1
        local c8 = string.find(chars, string.sub(input, i + 7, i + 7), 1, true) - 1
        local c = bit.bor(bit.lshift(c8, 28), bit.lshift(c7, 24), bit.lshift(c6, 20), bit.lshift(c5, 16), bit.lshift(c4, 12), bit.lshift(c3, 8), bit.lshift(c2, 4), c1)
        output = output .. string.char(c)
        i = i + 8
    end
    return output
end

return {
    encode = encode,
    decode = decode
}