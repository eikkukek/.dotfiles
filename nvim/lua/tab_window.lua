local E = {}

E.open = function()

	local buf = vim.api.nvim_create_buf(true, false)
	local tabs = {}

	local width = 0

	for i = 1, vim.fn.tabpagenr('$') do
		local winnr = vim.fn.tabpagewinnr(i)
		local buflist = vim.fn.tabpagebuflist(i)
		local bufnr = buflist[winnr]
		if bufnr ~= nil then
			local bufname = vim.fn.bufname(bufnr)
			local name = bufname ~= '' and vim.fn.fnamemodify(bufname, ':~:.') or '[No Name]'
			name = i .. ': ' .. name
			width = math.max(width, #name)
			tabs[i] = name
		end
	end

	if #tabs == 0 then
		return
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, tabs)

	local height = #tabs
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
	})

	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'filetype', 'tab_select')

	vim.cmd('normal! gg')
	vim.api.nvim_buf_add_highlight(buf, -1, "Visual", 0, 0, -1)

	local active_tab = vim.fn.tabpagenr()
	vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
	vim.api.nvim_win_set_cursor(0, { active_tab, 0 })
	vim.api.nvim_buf_add_highlight(buf, -1, "Visual", active_tab - 1, 0, -1)

	vim.keymap.set("n", "j", function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		if line < #tabs then
			vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
			vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
			vim.api.nvim_buf_add_highlight(buf, -1, "Visual", line, 0, -1)
		else
			vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			vim.api.nvim_buf_add_highlight(buf, -1, "Visual", 0, 0, -1)
		end
	end, { buffer = buf })

	vim.keymap.set("n", "k", function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		if line > 1 then
			vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
			vim.api.nvim_win_set_cursor(0, { line - 1, 0 })
			vim.api.nvim_buf_add_highlight(buf, -1, "Visual", line - 2, 0, -1)
		else
			vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
			vim.api.nvim_win_set_cursor(0, { #tabs, 0 })
			vim.api.nvim_buf_add_highlight(buf, -1, "Visual", #tabs - 1, 0, -1)
		end
	end, { buffer = buf })

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
		vim.cmd('tabn' .. line)
	end, { buffer = buf })

	vim.keymap.set("n", "<Esc>", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end	
	end)

	vim.api.nvim_create_autocmd({"BufLeave", "WinLeave"}, {
		buffer = buf,
		callback = function()
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_win_close(win, true)
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	})
end

return E
