local E = {}

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			cargo = { allFeatures = true },
			checkOnSave = true,
		},
	}
})

vim.lsp.enable({'rust_analyzer'})

local lsp_common = require 'lsp_common'

E.setup = function()

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "rust",
		callback = function()
			vim.keymap.set("n", "K",
				function()
					E.toggle_diagnostic = not E.toggle_diagnostic
				end,
				{ buffer = true }
			)
			vim.keymap.set("n", "<leader>+",
				function()
					E.toggle_expand = not E.toggle_expand
				end
			)
			vim.keymap.set("n", "§",
				function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(win).relative ~= "" then
							vim.api.nvim_win_close(win, false)
						end
					end
				end
			)
			vim.diagnostic.config({
				float = {
						border = "rounded",
						source = "always",
						header = "",
						prefix = "",
						format = function(diagnostic)
							local relatedInformation = diagnostic.user_data.lsp.relatedInformation
							if relatedInformation and #relatedInformation then
								return string.format("[%s] %s \n%s %s:%i:%i",
									vim.diagnostic.severity[diagnostic.severity],
									diagnostic.message,
									relatedInformation[1].message,
									relatedInformation[1].location.uri,
									relatedInformation[1].location.range.start.line,
									relatedInformation[1].location.range.start.character
								)
							end
							return string.format("[%s] %s",
								vim.diagnostic.severity[diagnostic.severity],
								diagnostic.message
							)
						end
					},
					signs = true,
					underline = true,
					severity_sort = true,
			})
		end
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)

			E.rust_lsp_progress = E.rust_lsp_progress or {}
			E.rust_lsp_progress.active_tokens = E.rust_lsp_progress.active_tokens or {}

			local original_handler = vim.lsp.handlers["$/progress"]

			vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)

				local value = result.value
				local token = result.token

				if token:match("rust") then
					if value.kind == "begin" then
						E.rust_lsp_progress.active_tokens[token] = true
					elseif value.kind == "end" then
						E.rust_lsp_progress.active_tokens[token] = nil
					end
				end

				if original_handler then
					original_handler(err, result, ctx, config)
				end
			end
		end
	})

	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			E.toggle_expand = false
		end,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			if vim.bo.filetype ~= "rust" then
				return
			end
			local lnum = vim.fn.line(".") - 1
			local col = vim.fn.col(".") - 1
			local diagnostics = vim.diagnostic.get(0, {
				lnum = lnum,
			})
			local cursor_diagnostics = vim.tbl_filter(
				function(d)
					local end_lnum = d.end_lnum
					if end_lnum == lnum then
						local end_col = d.end_col
						if end_col == d.col then
							end_col = d.col + 1
						end
						return d.col <= col and col < end_col
					end
					return lnum < end_lnum
				end,
				diagnostics
			)
			if #cursor_diagnostics > 0 then
				if E.toggle_diagnostic then
					local win = vim.api.nvim_get_current_win()
					local buf = vim.api.nvim_win_get_buf(win)
					if E.rust_lsp_progress then
						lsp_common.hover_doc(win, buf, "rust_analyzer", E.toggle_expand)
					end
				else
					vim.diagnostic.open_float(
						0,
						{
							scope = "cursor";
							focusable = false,
							severity_sort = true,
						}
					)
				end
			else
				E.toggle_diagnostic = false
				local win = vim.api.nvim_get_current_win()
				local buf = vim.api.nvim_win_get_buf(win)
				if E.rust_lsp_progress then
					lsp_common.hover_doc(win, buf, "rust_analyzer", E.toggle_expand)
				end
			end
		end
	})
end

return E
