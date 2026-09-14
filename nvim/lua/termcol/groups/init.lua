local M = {}

function M.get(colors, groups)
	require("termcol/groups/base").get(colors, groups)
	require("termcol/groups/treesitter").get(colors, groups)
	require("termcol/groups/headlines").get(colors, groups)
	require("termcol/groups/rust").get(colors, groups)
end

return M
