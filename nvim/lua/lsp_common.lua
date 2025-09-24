local E = {}

E.hover_doc = function(win, buf, client, toggle_expand)
	local clients = vim.lsp.get_clients({ bufnr = buf, name = client })
	if not clients or #clients == 0 then
		return
	end
	local offset_encoding = clients[1].offset_encoding
	if not offset_encoding then
		return
	end
	local params = vim.lsp.util.make_position_params(win, offset_encoding)
	vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)

		if err then
			if err.message ~= "content changed" and err.message ~= "content modified" then
				vim.notify("Hover error: " .. err.message, vim.log.levels.ERROR)
			end
			return
		end

		if not (result and result.contents) then return end

		local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

		if #markdown_lines == 0 then
			return
		end

		local max_width = 80

		if toggle_expand then
			for _, line in ipairs(markdown_lines) do
				max_width = math.max(max_width, #line)
			end
		end

		local config = config or {}
		config.focusable = false
		config.border = "rounded"
		config.max_width = max_width
		config.max_height = 50
		config.wrap = false

		local bufnr, winnr = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)

		vim.api.nvim_win_set_option(winnr, "linebreak", true)

		vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

		vim.schedule(function()
			if vim.api.nvim_buf_is_valid then
				return
			end
			vim.treesitter.start(bufnr, "markdown")
			local ok, headlines = pcall(require, "headlines")
			if ok and headlines.setup_buffer then
				headlines.setup_buffer(bufnr)
			elseif ok and headlines.refresh then
				headlines.refresh()
			end
		end)
	end)
end

return E
