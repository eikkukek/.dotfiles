local M = {}

local mix = require("termcol/util").mix

function M.get(colors, groups)
	groups["CursorLine"] = { bg = mix(colors.bright_black, colors.black, 0.5) }
	groups["Comment"] = {
		cterm = { italic },
		italic = true,
		fg = mix(colors.bright_black, colors.white, 0.3)
	}

	groups["StatusLine"] = { fg = colors.white, bg = colors.bg }
	groups["StatusLineNC"] = { link = "StatusLine" }
	groups["TabLine"] = { fg = colors.white }

	groups["Constant"] = { fg = colors.orange }
	groups["String"] = { fg = colors.bright_green }
	groups["Character"] = { link = "String" }
	groups["Identifier"] = { fg = colors.bright_magenta }
	groups["Function"] = { fg = colors.blue }
	groups["Statement"] = { fg = colors.bright_magenta }
	groups["Conditional"] = { link = "Statement" }
	groups["Repeat"] = { link = "Statement" }
	groups["Label"] = { link = "Statement" }
	groups["Exception"] = { link = "Statement" }
	groups["Operator"] = { fg = colors.bright_blue }
	groups["Keyword"] = { cterm = { italic }, italic = true, fg = colors.bright_blue }
	groups["PreProc"] = { fg = colors.bright_blue }
	groups["Include"] = { link = "PreProc" }
	groups["Define"] = { link = "PreProc" }
	groups["Macro"] = { link = "PreProc" }
	groups["PreCondit"] = { link = "PreProc" }
	groups["Type"] = { fg = colors.bright_cyan }
	groups["StorageClass"] = { link = "Type" }
	groups["Structure"] = { link = "Type" }
	groups["Typedef"] = { link = "Type" }
	groups["Special"] = { fg = colors.blue }
	groups["SpecialChar"] = { link = "Special" }
	groups["Tag"] = { link = "Special" }
	groups["Delimiter"] = { link = "Special" }
	groups["SpecialComment"] = { link = "Special" }
	groups["Debug"] = { fg = colors.yellow }
	groups["Underlined"] = { cterm = { underline }, underline = true }
	groups["Ignore"] = { link = "Normal" }
	groups["Error"] = { fg = colors.bright_red  }
	groups["Todo"] = { fg = colors.black, bg = colors.bright_yellow }

	groups["DiagnosticError"] = { fg = colors.error }
	groups["DiagnosticWarn"] = { fg = colors.warn }
	groups["DiagnosticInfo"] = { fg = colors.info }
	groups["DiagnosticHint"] = { fg = colors.hint }

	groups["DiagnosticUnderlineError"] = { undercurl = true, sp = colors.error }
	groups["DiagnosticUnderlineWarn"] = { undercurl = true, sp = colors.warn }
	groups["DiagnosticUnderlineInfo"] = { undercurl = true, sp = colors.info }
	groups["DiagnosticUnderlineHint"] = { undercurl = true, sp = colors.hint }

	groups["DiagnosticDeprecated"] = {
		fg = colors.bright_black,
		cterm = { strikethrough },
		strikethrough = true
	}
end

return M
