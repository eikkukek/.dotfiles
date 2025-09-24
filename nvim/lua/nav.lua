function win_try_nav(dir)

	local current_winnr = vim.fn.winnr()

	vim.cmd('wincmd ' .. dir)

	local new_winnr = vim.fn.winnr()

	return current_winnr ~= new_winnr
end

-- move
vim.keymap.set('n', '<C-h>',
	function()

		if win_try_nav('h') then
			return
		end

		local env = require 'env'

		if env.tmux_win_id == nil then
			vim.notify("tmux window ID was nil", vim.log.levels.ERROR)
			return
		end

		local cmd = string.format("tmux if -t %s -F '#{pane_at_left}' 'run-shell \"swaymsg focus left\"' 'select-pane -t %s -L'",
			env.tmux_win_id, env.tmux_win_id)
		
		vim.fn.system(cmd)
	end
)

vim.keymap.set('n', '<C-j>',
	function()

		if win_try_nav('j') then
			return
		end

		local env = require 'env'

		if env.tmux_win_id == nil then
			vim.notify("tmux window ID was nil", vim.log.levels.ERROR)
			return
		end

		local cmd = string.format("tmux if -t %s -F '#{pane_at_bottom}' 'run-shell \"swaymsg focus down\"' \"select-pane -t %s -D\"",
			env.tmux_win_id, env.tmux_win_id)

		vim.fn.system(cmd)
	end
)

vim.keymap.set('n', '<C-k>',
	function()

		if win_try_nav('k') then
			return
		end

		local env = require 'env'

		if env.tmux_win_id == nil then
			vim.notify("tmux window ID was nil", vim.log.levels.ERROR)
			return
		end

		local cmd = string.format("tmux if -t %s -F '#{pane_at_top}' 'run-shell \"swaymsg focus up\"' \"select-pane -t %s -U\"",
			env.tmux_win_id, env.tmux_win_id)

		vim.fn.system(cmd)
	end
)

vim.keymap.set('n', '<C-l>',
	function()

		if win_try_nav('l') then
			return
		end

		local env = require 'env'

		if env.tmux_win_id == nil then
			vim.notify("tmux window ID was nil", vim.log.levels.ERROR)
			return
		end

		local cmd = string.format("tmux if -t %s -F '#{pane_at_right}' 'run-shell \"swaymsg focus right\"' \"select-pane -t %s -R\"",
			env.tmux_win_id, env.tmux_win_id)

		vim.fn.system(cmd)
	end
)

-- resize
vim.keymap.set('n', '<C-M-h>',
	function()
		require 'tmux'.resize_left()
	end
)

vim.keymap.set('n', '<C-M-j>',
	function()
		require 'tmux'.resize_bottom()
	end
)

vim.keymap.set('n', '<C-M-k>',
	function()
		require 'tmux'.resize_top()
	end
)

vim.keymap.set('n', '<C-M-l>',
	function()
		require 'tmux'.resize_right()
	end
)

-- swap
vim.keymap.set('n', 'zh',
	function()
		require 'tmux'.swap_left()
	end
)

vim.keymap.set('n', 'zj',
	function()
		require 'tmux'.swap_bottom()
	end
)

vim.keymap.set('n', 'zk',
	function()
		require 'tmux'.swap_top()
	end
)

vim.keymap.set('n', 'zl',
	function()
		require 'tmux'.swap_right()
	end
)
