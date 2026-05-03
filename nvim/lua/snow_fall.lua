local M = {}

M.setup = function(intensity)
	local ext_ns = vim.api.nvim_create_namespace("SnowFall")
	vim.api.nvim_set_hl(0, "SnowFall", { fg = "#40dacd", })
	local timer = vim.loop.new_timer()
	local wins = {}
	local spawn_id = 0
	local particles = { "•", "·", "‧", "✹", }
	math.randomseed(os.time())
	local spawn_flake = function()
		spawn_id = spawn_id + 1
		return {
			key = spawn_id,
			snow_flake = {
				key = spawn_id,
				line = 0,
				col = math.random(200),
				direction = 1,
				particle = particles[math.random(#particles)],
			},
		}
	end
	local update_flake = function(flake, buf)
		if vim.api.nvim_buf_is_valid(buf.bufnr) == false or flake.line > vim.api.nvim_buf_line_count(buf.bufnr) then
			table.remove(buf.snow_flakes, flake.key)
		else
			local random = math.random(-10, 10)
			if random < -8 then
				flake.direction = -1
			elseif random > 8 then
				flake.direction = 1
			end
			flake.col = flake.col + flake.direction
			if flake.col < 0 then
				flake.col = 0
			end
			vim.api.nvim_buf_set_extmark(buf.bufnr, ext_ns, flake.line, 0, {
				virt_text = { { flake.particle, "SnowFall", } },
				virt_text_pos = "overlay",
				virt_text_win_col = flake.col,
				hl_mode = "combine",
			})
			flake.line = flake.line + 1
		end
	end
	local register_win = function(winnr)
		local id = vim.fn.win_getid(winnr)
		wins[id] = {
			bufs = {},
		}
		vim.api.nvim_create_autocmd({"WinClosed"}, {
			pattern = tostring(id),
			callback = function()
				table.remove(wins, id)
			end
		})
		return wins[id]
	end
	local register_buf = function(win, bufnr)
		win.bufs[bufnr] = {
			bufnr = bufnr,
			spawn_counter = 0,
			next_spawn_tick = 0,
			snow_flakes = {},
		}
		vim.api.nvim_create_autocmd({"BufDelete"}, {
			buffer = bufnr,
			callback = function()
				table.remove(win.bufs, bufnr)
			end
		})
	end
	timer:start(
		0,
		33,
		vim.schedule_wrap(function()
			local tabnr = vim.fn.tabpagenr()
			local winnr = vim.fn.tabpagewinnr(tabnr)
			local buflist = vim.fn.tabpagebuflist(tabnr)
			local bufnr = buflist[winnr]
			local id = vim.fn.win_getid(winnr)
			local win = wins[id]
			if win ~= nil and bufnr ~= nil then
				if win.bufs[bufnr] == nil then
					register_buf(win, bufnr)
				end
			else
				register_buf(register_win(winnr), bufnr)
			end
			for k, win in pairs(wins) do
				for k, buf in pairs(win.bufs) do
					if vim.api.nvim_buf_is_valid(buf.bufnr) then
						vim.api.nvim_buf_clear_namespace(
							buf.bufnr,
							ext_ns,
							0,
							vim.api.nvim_buf_line_count(buf.bufnr)
						)
					else
						table.remove(win.bufs, buf.bufnr)
					end
					if buf.spawn_counter >= buf.next_spawn_tick then
						for i = 0,math.random(1,intensity),1 do
							local spawn = spawn_flake()
							buf.snow_flakes[spawn.key] = spawn.snow_flake
						end
						buf.spawn_counter = 0
						buf.next_spawn_tick = math.random(1, 3)
					end
					buf.spawn_counter = buf.spawn_counter + 1
					for k, flake in pairs(buf.snow_flakes) do
						update_flake(flake, buf, line_count)
					end
				end
			end
		end)
	)
end

return M
