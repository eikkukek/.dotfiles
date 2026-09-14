local M = {}

local mix = require 'termcol/util'.mix

function M.get(colors, groups)

	local al_path = vim.fn.system(
		"printf " ..
		vim.fn.system(
			"toml get ~/.config/alacritty/alacritty.toml general.import | sed 's/[][]//g'"
		)
	)
	local al_fmt = "toml get " .. al_path
	local sed_trim = " | sed -e 's/[\"]//g' | tr -d '\n'"

	colors.bg = vim.fn.system(al_fmt .. " colors.primary.background" .. sed_trim)
	colors.fg = vim.fn.system(al_fmt .. " colors.primary.foreground" .. sed_trim)
	colors.black = vim.fn.system(al_fmt .. " colors.normal.black" .. sed_trim)
	colors.red = vim.fn.system(al_fmt .. " colors.normal.red" .. sed_trim)
	colors.green = vim.fn.system(al_fmt .. " colors.normal.green" .. sed_trim)
	colors.yellow = vim.fn.system(al_fmt .. " colors.normal.yellow" .. sed_trim)
	colors.blue = vim.fn.system(al_fmt .. " colors.normal.blue" .. sed_trim)
	colors.magenta = vim.fn.system(al_fmt .. " colors.normal.magenta" .. sed_trim)
	colors.cyan = vim.fn.system(al_fmt .. " colors.normal.cyan" .. sed_trim)
	colors.white = vim.fn.system(al_fmt .. " colors.normal.white" .. sed_trim)
	colors.bright_black = vim.fn.system(al_fmt .. " colors.bright.black" .. sed_trim)
	colors.bright_red = vim.fn.system(al_fmt .. " colors.bright.red" .. sed_trim)
	colors.bright_green = vim.fn.system(al_fmt .. " colors.bright.green" .. sed_trim)
	colors.bright_yellow = vim.fn.system(al_fmt .. " colors.bright.yellow" .. sed_trim)
	colors.bright_blue = vim.fn.system(al_fmt .. " colors.bright.blue" .. sed_trim)
	colors.bright_magenta = vim.fn.system(al_fmt .. " colors.bright.magenta" .. sed_trim)
	colors.bright_cyan = vim.fn.system(al_fmt .. " colors.bright.cyan" .. sed_trim)
	colors.bright_white = vim.fn.system(al_fmt .. " colors.bright.white" .. sed_trim)

	colors.orange = mix(mix(colors.red, colors.yellow, 0.4), colors.white, 0.1)

	colors.error = colors.bright_red
	colors.warn = colors.bright_yellow
	colors.info = colors.bright_blue
	colors.hint = colors.bright_green
end

return M
