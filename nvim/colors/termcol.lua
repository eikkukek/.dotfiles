vim.cmd('highlight clear')
vim.g.colors_name = "termcol"

vim.cmd [[
	highlight Normal guibg=NONE ctermbg=NONE
	highlight NormalNC guibg=NONE ctermbg=NONE
	highlight EndOfBuffer guibg=NONE ctermbg=NONE
	highlight LineNr guibg=NONE ctermbg=NONE
	highlight SignColumn guibg=NONE ctermbg=NONE
	highlight FloatBorder guibg=NONE ctermbg=NONE
	highlight NormalFloat guibg=NONE ctermbg=NONE
]]

local colors = {}
local groups = {}
require 'termcol/palette'.get(colors, groups)
require 'termcol/groups'.get(colors, groups)

for group, opt in pairs(groups) do
	vim.api.nvim_set_hl(0, group, opt)
end
