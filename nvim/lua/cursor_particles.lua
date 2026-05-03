local M = {}

M.setup = function(tick_time, spawn_frequency)
	
	tick_time = 33
	spawn_frequency = 3
	local symbol_set_1 = {
		id = 0,
		set = {
			"",
			"",
			""
		},
	}
	local symbol_set_2 = {
		id = 1,
		set = {
			"󰔶",
			"",
			"",
			"",
			"",
		},
	}

	local symbol_sets = {}
	symbol_sets[1] = symbol_set_1
	symbol_sets[2] = symbol_set_2

	vim.api.nvim_set_hl(0, "GeometricParticles0", { fg = "#8470c1", })
	vim.api.nvim_set_hl(0, "GeometricParticles1", { fg = "#70c070", })
	vim.api.nvim_set_hl(0, "GeometricParticles2", { fg = "#bf6f6f", })
	vim.api.nvim_set_hl(0, "GeometricParticles3", { fg = "#a8bf6f", })

	local hls = {
		"GeometricParticles0",
		"GeometricParticles1",
		"GeometricParticles2",
		"GeometricParticles3",
	}

	local ext_ns = vim.api.nvim_create_namespace("GeometricParticles")
	local spawn_id = 0

	local particles = {}

	local spawn_counter = 0
	local prev_bufnr = 0

	local timer = vim.loop.new_timer()

	math.randomseed(os.time())

	local spawn_particle = function(line, col, bufnr)
		spawn_id = spawn_id + 1
		col = col + math.random(-1, 1)
		if col < 0 then
			col = 0
		end
		return {
			spawn_id = spawn_id,
			bufnr = bufnr,
			line = line,
			col = col,
			lifetime = 8,
			symbol_set = symbol_sets[math.random(#symbol_sets)],
			hl = hls[math.random(#hls)],
		}
	end

	local get_symbol = function(symbol_set, lifetime)
		if symbol_set.id == 0 then
			if lifetime > 6 then
				return symbol_set.set[1]
			elseif lifetime > 3 then
				return symbol_set.set[2]
			else
				return symbol_set.set[3]
			end
		end
		if symbol_set.id == 1 then
			if lifetime > 7 then
				return symbol_set.set[1]
			elseif lifetime > 3 then
				return symbol_set.set[2]
			else
				return symbol_set.set[3 + math.random(2)]
			end
		end
	end

	local update_particle = function(particle)
		if vim.api.nvim_buf_is_valid(particle.bufnr) == false or particle.lifetime == 0 or particle.line < 0 then
			table.remove(particles, particle.spawn_id)
		else
			vim.api.nvim_buf_set_extmark(particle.bufnr, ext_ns, particle.line, 0, {
				virt_text = { { get_symbol(particle.symbol_set, particle.lifetime), particle.hl, } },
				virt_text_pos = "overlay",
				virt_text_win_col = particle.col,
				hl_mode = "combine",
			})
			particle.line = particle.line - 1
			particle.lifetime = particle.lifetime - 1
		end
	end	
	timer:start(
		0,
		tick_time,
		vim.schedule_wrap(function()
			local bufnr = vim.api.nvim_win_get_buf(0)
			if spawn_counter >= spawn_frequency then
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				col = vim.fn.virtcol(".") - 1
				local particle = spawn_particle(line - 2, col, bufnr)
				particles[particle.spawn_id] = particle
				spawn_counter = 0
			end
			if bufnr ~= prev_bufnr and vim.api.nvim_buf_is_valid(prev_bufnr) then
				vim.api.nvim_buf_clear_namespace(
					prev_bufnr,
					ext_ns,
					0,
					vim.api.nvim_buf_line_count(prev_bufnr)
				)
			end
			vim.api.nvim_buf_clear_namespace(
				bufnr,
				ext_ns,
				0,
				vim.api.nvim_buf_line_count(bufnr)
			)
			prev_bufnr = bufnr
			for k, particle in pairs(particles) do
				update_particle(particle)
			end
			spawn_counter = spawn_counter + 1
		end)
	)
end

return M
