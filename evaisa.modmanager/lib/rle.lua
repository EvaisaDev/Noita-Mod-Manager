-- Run-Length Encoding Compression algorithm  implementation

local function encode(string)
    local result = {}
    local lastChar = string:sub(1, 1)
    local count = 1
    for i = 2, #string do
        local char = string:sub(i, i)
        if char == lastChar then
            count = count + 1
        else
            table.insert(result, lastChar)
            table.insert(result, count)
            lastChar = char
            count = 1
        end
    end
    table.insert(result, lastChar)
    table.insert(result, count)
    return table.concat(result)
end

local function decode(string)
    local result = {}
    for i = 1, #string, 2 do
        local char = string:sub(i, i)
        local count = string:sub(i + 1, i + 1)
        for j = 1, count do
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

return {
    encode = encode,
    decode = decode,
}