local M = {}

local mix = require 'termcol/util'.mix

function M.get(colors)

	local al_path = vim.fn.system(
		"printf " ..
		vim.fn.system(
			"toml get ~/.config/alacritty/alacritty.toml general.import | sed 's/[][]//g'"
		)
	)
	local al_fmt = "toml get " .. al_path
	local sed_trim = " | sed -e 's/[\"]//g' | tr -d '\n'"

	local bg = vim.fn.system(al_fmt .. " colors.primary.background" .. sed_trim)
	local fg = vim.fn.system(al_fmt .. " colors.primary.foreground" .. sed_trim)
	local black = vim.fn.system(al_fmt .. " colors.normal.black" .. sed_trim)
	local red = vim.fn.system(al_fmt .. " colors.normal.red" .. sed_trim)
	local green = vim.fn.system(al_fmt .. " colors.normal.green" .. sed_trim)
	local yellow = vim.fn.system(al_fmt .. " colors.normal.yellow" .. sed_trim)
	local blue = vim.fn.system(al_fmt .. " colors.normal.blue" .. sed_trim)
	local magenta = vim.fn.system(al_fmt .. " colors.normal.magenta" .. sed_trim)
	local cyan = vim.fn.system(al_fmt .. " colors.normal.cyan" .. sed_trim)
	local white = vim.fn.system(al_fmt .. " colors.normal.white" .. sed_trim)
	local bright_black = vim.fn.system(al_fmt .. " colors.bright.black" .. sed_trim)
	local bright_red = vim.fn.system(al_fmt .. " colors.bright.red" .. sed_trim)
	local bright_green = vim.fn.system(al_fmt .. " colors.bright.green" .. sed_trim)
	local bright_yellow = vim.fn.system(al_fmt .. " colors.bright.yellow" .. sed_trim)
	local bright_blue = vim.fn.system(al_fmt .. " colors.bright.blue" .. sed_trim)
	local bright_magenta = vim.fn.system(al_fmt .. " colors.bright.magenta" .. sed_trim)
	local bright_cyan = vim.fn.system(al_fmt .. " colors.bright.cyan" .. sed_trim)
	local bright_white = vim.fn.system(al_fmt .. " colors.bright.white" .. sed_trim)

	colors.bg = bg

	colors.fg = fg
	colors.fg_dark = mix(fg, black, 0.2)
	colors.fg_gutter = mix(fg, black, 0.5)

	colors.blue = bright_blue
	colors.blue0 = mix(blue, black, 0.5)
	colors.blue1 = blue
	colors.blue2 = mix(blue, black, 0.1)
	colors.blue5 = mix(bright_blue, white, 0.3)
	colors.blue6 = mix(bright_blue, white, 0.5)
	colors.blue7 = mix(blue, black, 0.8)

	colors.comment = mix(bright_black, white, 0.3)

	colors.cyan = cyan

	colors.dark3 = bright_black
	colors.dark5 = mix(colors.comment, white, 0.1)

	colors.green = green
	colors.green1 = bright_green
	colors.green2 = mix(bright_green, bright_blue, 0.3)

	colors.magenta = bright_magenta
	colors.magenta2 = mix(bright_magenta, bright_red, 0.5)

	colors.orange = mix(red, yellow, 0.5)

	colors.purple = mix(magenta, black, 0.1)

	colors.red = bright_red
	colors.red1 = red

	colors.teal = mix(green, yellow, 0.5)

	colors.yellow = yellow

	colors.git = {
		add = green,
		change = blue,
		delete = red,
	}

	vim.notify 'here'
end

return M
