local M = {}

local mix = require 'termcol/util'.mix

function M.get(colors, groups)
	groups["CodeBlock"] = {}
	groups["Headline"] = { fg = colors.white, bg = colors.bright_black }
end

return M
