vim.cmd('highlight clear')

require 'tokyonight'.setup({
	style = "night",
	on_colors = function(colors)
		require 'tokyoterm/palette'.get(colors)
	end
})

vim.cmd([[colorscheme tokyonight]])

vim.cmd [[
	highlight Normal guibg=NONE ctermbg=NONE
	highlight NormalNC guibg=NONE ctermbg=NONE
	highlight EndOfBuffer guibg=NONE ctermbg=NONE
	highlight LineNr guibg=NONE ctermbg=NONE
	highlight SignColumn guibg=NONE ctermbg=NONE
	highlight FloatBorder guibg=NONE ctermbg=NONE
	highlight NormalFloat guibg=NONE ctermbg=NONE
]]

vim.g.colors_name = "tokyoterm"
