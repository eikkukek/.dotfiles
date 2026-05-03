local M = {}
M.setup = function(height, particle_intensity)

	local timer = vim.loop.new_timer()
	local snow_fall_timer = vim.loop.new_timer()

	vim.api.nvim_set_hl(0, 'AudioVis', { fg = '#9ece6a', })
	local ext_ns = vim.api.nvim_create_namespace('AudioVis')
	local symbol = "▗"

	vim.api.nvim_set_hl(0, "SnowFall", { fg = "#40dacd", })
	local particles = { "•", "·", "‧", "✹", }
	math.randomseed(os.time())

	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = 1,
		height = height,
		row = 0,
		col = 0,
		border = 'rounded',
	})

	local lines = {}
	for i = 1, height do
		lines[i] = ""
	end

	vim.api.nvim_buf_set_lines(buf, 0, height, false, lines)

	local width = 0

	local flakes = {}
	local flake_spawn_counter = 0
	local next_flake_spawn_tick = 0 
	local particle_id = 0

	local spawn_flake = function()
		particle_id = particle_id + 1
		return {
			key = particle_id,
			flake = {
				key = particle_id,
				line = 0,
				col = math.random(width),
				direction = 1,
				particle = particles[math.random(#particles)],
			},
		}
	end

	local update_flake = function(flake, update_pos)
		if flake.line > height then
			table.remove(flakes, flake.key)
		else
			if update_pos then
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
			end
			vim.api.nvim_buf_set_extmark(buf, ext_ns, flake.line, 0, {
				virt_text = { { flake.particle, "SnowFall", } },
				virt_text_pos = "overlay",
				virt_text_win_col = flake.col,
				hl_mode = "combine",
			})
			if update_pos then
				flake.line = flake.line + 1
			end
		end
	end

	vim.api.nvim_create_autocmd({"TabEnter"}, {
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			local id = vim.fn.win_getid(vim.fn.winnr())
			win = vim.api.nvim_open_win(buf, true, {
				relative = 'editor',
				width = width,
				height = height,
				row = 1,
				col = vim.o.columns - width,
				style = 'minimal',
				border = 'rounded',
				focusable = false,
			})
			vim.api.nvim_set_current_win(id)
		end
	})

	local flake_update = 0
	local flake_update_tick = 4

	timer:start(
		0,
		33,
		vim.schedule_wrap(function()
			vim.api.nvim_buf_clear_namespace(
				buf,
				ext_ns,
				0,
				vim.api.nvim_buf_line_count(buf)
			)
			local size = height 
			local size_half = size / 2
			local step = size / 100
			local f = io.open('/tmp/.cava-raw', 'r')
			if not f then
				return
			end
			local line = f:read('*l')
			local col = 0
			while line ~= nil do
				local level = tonumber(line)
				if level == nil then
					return
				end
				local iter = size
				for i = 0, size do
					local val = iter / step
					if val <= level then
						vim.api.nvim_buf_set_extmark(buf, ext_ns, i, 0, {
							virt_text = { { symbol, 'AudioVis', } },
							virt_text_pos = 'overlay',
							virt_text_win_col = col,
							hl_mode = 'combine',
						})
					end
					iter = iter - 1
				end
				col = col + 1
				line = f:read('*l')
			end
			if false then
			if flake_spawn_counter >= next_flake_spawn_tick then
				for i = 0,math.random(1,particle_intensity),1 do
					local spawn = spawn_flake()
					flakes[spawn.key] = spawn.flake
				end
				flake_spawn_counter = 0
				next_flake_spawn_tick = math.random(3, 6)
			end
			flake_spawn_counter = flake_spawn_counter + 1
			local update_pos = flake_update >= flake_update_tick
			for k, flake in pairs(flakes) do
				update_flake(flake, update_pos)
			end
			if update_pos then
				flake_update = 0
			end
			flake_update = flake_update + 1
			end
			if width ~= col then
				vim.api.nvim_buf_set_option(buf, 'modifiable', true)
				vim.api.nvim_buf_set_lines(buf, 0, height, false, lines)
				vim.api.nvim_buf_set_option(buf, 'modifiable', false)
				width = col
			end
			if width > 0 and vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_set_config(win, {
					relative = 'editor',
					width = width,
					height = height,
					row = 1,
					col = vim.o.columns - width,
					style = 'minimal',
					border = 'rounded',
					focusable = false,
				})
			end
			f:close()	
		end)
	)
end
return M
