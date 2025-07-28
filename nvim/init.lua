-- plugins
require 'paq' {

    'savq/paq-nvim', -- let paq manage itself

    'lukas-reineke/indent-blankline.nvim', -- indent lines
	'lukas-reineke/headlines.nvim', -- better markdown

	'nvim-lua/plenary.nvim', -- telescope dependency

	{ 'nvim-telescope/telescope.nvim', branch = '0.1.8' }, -- fuzzy finder

	'aserowy/tmux.nvim',

	'neovim/nvim-lspconfig',

	{ 'nvim-treesitter/nvim-treesitter', branch = 'master', build = ':TSUpdate' },

	{ "nvim-treesitter/playground", cmd = { "TSHighlightCapturesUnderCursor" } },

    -- code completion
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',

	'hrsh7th/cmp-vsnip',
	'hrsh7th/vim-vsnip',

	-- time tracking
	'wakatime/vim-wakatime',

	-- color theme	
	'folke/tokyonight.nvim',

	-- notifications
	'j-hui/fidget.nvim',
}

require	'ibl'.setup { -- setup indent blankline
    scope = { -- disable scope
		enabled = false,
    },
}

require 'fidget'.setup()

require 'nvim-treesitter.configs'.setup({
	ensure_installed = { "markdown", "markdown_inline", "rust" },
	highlight = { enable = true },
})

require 'headlines'.setup()

-- tmux setup
require 'tmux'.setup {
	copy_sync = {
		enable = true,
	},
	navigation = {
		cycle_navigation = false,
		enable_default_keybindings = false,
		persist_zoom = false,
	},	
	resize = {
		enable_default_keybindings = false,
	},
	swap = {
		enable_default_keybindings = false,
	}
}

-- tmux/navigation keymaps
require 'nav'

local rust_lsp = require 'rust_lsp'
rust_lsp.setup()

-- vim config

vim.g.mapleader = ';'

vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.updatetime = 300

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLineRelative()"

function _G.TabLineRelative()
	local s = ''
	local tab_count = vim.fn.tabpagenr('$')
	for i = 1, tab_count do
		if i ~= vim.fn.tabpagenr() then
			goto continue
		end
		local winnr = vim.fn.tabpagewinnr(i)
		local buflist = vim.fn.tabpagebuflist(i)
		local bufnr = buflist[winnr]
		if bufnr ~= nil then
			local bufname = vim.fn.bufname(bufnr)
			local name = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]'
			s = s .. '%#TabLineSel#'
			s = s .. name .. ' [' .. i .. ']'
		end
		::continue::
	end
	s = s .. '%#TabLine#' .. ' tab count: ' .. tab_count
	return s .. '%#TabLineFill#'
end

vim.keymap.set('n', '<leader>a',
	function()
		local pagenr = vim.fn.tabpagenr()
		pagenr = (pagenr - 2) % vim.fn.tabpagenr('$') + 1
		vim.cmd('tabn' .. pagenr)
	end,
	{ desc = 'Previous tab' }
)

vim.keymap.set('n', '<leader>d',
	function()
		local pagenr = vim.fn.tabpagenr()
		pagenr = pagenr % vim.fn.tabpagenr('$') + 1
		vim.cmd('tabn' .. pagenr)
	end,
	{ desc = 'Next tab' }
)

vim.keymap.set('n', '<leader>s',
	function()
		require 'tab_window'.open()
	end,
	{ desc = 'tab window' }
)

-- tab switch
for i = 1, 9 do
	vim.keymap.set('n', '<leader>' .. i,
		function()
			vim.cmd('silent! tabn' .. i)
		end,
		{ desc = 'Go to tab ' .. i, }
	)
end

vim.cmd([[filetype indent off]])

vim.g.clipboard = {
	name = 'wl-clipboard',
	copy = {
		['+'] = 'wl-copy',
		['*'] = 'wl-copy',
	},
	paste = {
		['+'] = 'wl-paste --no-newline',
		['*'] = 'wl-paste --no-newline',
	},
	cache_enable = 0,
}

-- telescope setup
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find_files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live_grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- color theme setup
vim.o.termguicolors = true
vim.cmd.colorscheme "tokyonight-night"
vim.cmd [[
	highlight Normal guibg=NONE ctermbg=NONE
	highlight NormalNC guibg=NONE ctermbg=NONE
	highlight EndOfBuffer guibg=NONE ctermbg=NONE
	highlight LineNr guibg=NONE ctermbg=NONE
	highlight SignColumn guibg=NONE ctermbg=NONE
	highlight FloatBorder guibg=NONE ctermbg=NONE
	highlight NormalFloat guibg=NONE ctermbg=NONE
]]

-- autocomplete setup
local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		--['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources(
		{
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		},
		{ name = 'buffer' }
	)
})
