local M = {}

function rgb(col)
	return {
		tonumber(col:sub(2, 3), 16),
		tonumber(col:sub(4, 5), 16),
		tonumber(col:sub(6, 7), 16)
	}
end

function M.mix(a, b, t)
	local a = rgb(a)
	local b = rgb(b)
	return string.format(
		"#%02x%02x%02x",
		(1 - t) * a[1] + t * b[1],
		(1 - t) * a[2] + t * b[2],
		(1 - t) * a[3] + t * b[3]
	)
end

return M
