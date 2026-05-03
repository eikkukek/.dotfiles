
local _insert = function(str1, str2, pos)
	return str1:sub(1, pos)..str2..str1:sub(pos + 1)
end

vim.keymap.set("x", "ms",
	function()
		local _start = vim.fn.getpos("v")
		local _end = vim.fn.getpos(".")
		if _start[2] == _end[2] and _start[3] < _end[3] then
			local text = vim.api.nvim_buf_get_text(
				_start[1],
				_start[2] - 1, _start[3] - 1,
				_end[2] - 1, _end[3],
				{}
			)[1]
			local replace = text
			local off = 0
			for i = 2, #text do
				local ch = text:sub(i, i)
				if string.match(ch, "%u") then
					replace = _insert(replace, "_", i - 1 + off)
					off = off + 1
				end
			end
			local line = vim.api.nvim_buf_get_lines(
				_start[1], _start[2] - 1, _start[2], false
			)[1]
			local line =
				line:sub(1, _start[3] - 1)..
				replace:upper()..
				line:sub(_end[3] + 1)
			vim.api.nvim_buf_set_lines(
				_start[1],
				_start[2] - 1, _start[2],
				false,
				{line}
			)
			vim.api.nvim_win_set_cursor(0, {_start[2], _start[3] - 1})
		end
	end
)


