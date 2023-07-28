local bit = require("bit")

function positive_number_to_bytes(n)
	assert(0 < n)
	local mask = 0xff
	local arr = {}
	local max_len = math.ceil(math.log(n, 2) / 8)
	local i = 0
	while (n > 0) do
		local masked = bit.band(n, mask)
		arr[max_len - i] = masked
		i = i + 1
		n = bit.rshift(n, 8)
	end
	return arr -- reverse this
end

function number_to_bytes(n)
	if (n == 0) then
		return { 0 }
	elseif (n < 0) then
		print("warning: negative number will be unrecoverable")
		return positive_number_to_bytes(-n)
	end
	return positive_number_to_bytes(n)
end

function bytes_to_unsigned_number(arr)
	-- the most significant byte starts at the lowest index
	local n = 0
	local size = #arr
	for i = 1, size do
		assert(0 <= arr[i] and arr[i] < 256)
		n = n + bit.lshift(1, 8 * (size - i)) * (arr[i]) -- [..., 2^16, 2^8, 2^0] * ...arr
	end
	return n
end

function bytes_to_string(bytes)
	if (bytes == nil) then return "" end
	local s = ""
	for i = 1, #bytes do
		s = s .. string.char(bytes[i])
	end
	return s
end

function string_to_bytes(s)
	if (s == nil) then return {} end
	local i = 1
	local arr = {}
	for c in s:gmatch(".", s) do
		arr[i] = string.byte(c)
		i = i + 1
	end
	return arr
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function test_encode_decode(n)
	assert(n >= 0, "program assumes number is nonnegative")
	local encoded = number_to_bytes(n)
	local decoded = bytes_to_unsigned_number(encoded)
	assert(decoded == n, "encoded {" .. n .. "} doesn't match decoded " .. dump(encoded))
end

function encode_workshop_ids(workshop_id_table)
	local output = ""
	for i = 1, #workshop_id_table do
		test_encode_decode(workshop_id_table[i])
		local encoded = number_to_bytes(workshop_id_table[i])
		output = output .. bytes_to_string(encoded) .. "/"
	end
	return output
end

function decode_workshop_ids(s)
	local recovered = {}
	local i = 1
	for k in string.gmatch(s, "([^/]+)/") do
		local recovered_str = string_to_bytes(k)
		recovered[i] = bytes_to_unsigned_number(recovered_str)
		i = i + 1
	end
	return recovered
end

return {
    encode = encode_workshop_ids,
    decode = decode_workshop_ids,
}