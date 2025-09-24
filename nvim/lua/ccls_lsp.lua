local E = {}

local lspconfig = require 'lspconfig'

local lsp_common = require 'lsp_common'

E.setup = function()


	lspconfig.ccls.setup({
		on_attach = function(client, bufnr)
		end,
		cmd = { "ccls" },
		init_options = {
			compilationDatabaseDirectory = "build",
		},
		root_dir = lspconfig.util.root_pattern("compile_commands.json", "CMakeLists.txt"),
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "ccls",
		callback = function()
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

	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			if vim.bo.filetype ~= "cpp" and vim.bo.filetype ~= "c" then
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
				vim.diagnostic.open_float(
					0,
					{
						scope = "cursor";
						focusable = false,
						severity_sort = true,
					}
				)
			else
				local win = vim.api.nvim_get_current_win()
				local buf = vim.api.nvim_win_get_buf(win)
				lsp_common.hover_doc(win, buf, "ccls", false)
			end
		end
	})
end

return E
