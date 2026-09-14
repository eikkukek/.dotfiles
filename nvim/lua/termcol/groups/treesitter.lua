local M = {}

local mix = require("termcol/util").mix

function M.get(colors, groups)
	groups["@keyword"] = {
		cterm = { italic },
		italic = true,
		fg = mix(colors.bright_magenta, colors.magenta, 0.5)
	}
	groups["@keyword.conditional"] = { link = "Conditional" }
	groups["@keyword.courotine"] = { link = "@keyword" }
	groups["@keyword.debug"] = { link = "Debug" }
	groups["@keyword.directive"] = { link = "PreProc" }
	groups["@keyword.directive.define"] = { link = "Define" }
	groups["@keyword.exception"] = { link = "Exception" }
	groups["@keyword.function"] = { fg = colors.bright_magenta }
	groups["@keyword.import"] = { link = "Include" }
	groups["@keyword.operator"] = { link = "@operator" }
	groups["@keyword.repeat"] = { link = "Repeat" }
	groups["@keyword.return"] = { link = "@keyword" }
	groups["@keyword.storage"] = { link = "StorageClass" }
	groups["@lsp.type.interface"] = { fg = colors.light_blue }
	groups["@type.builtin"] = { fg = mix(colors.bright_cyan, colors.black, 0.2) }
	groups["@operator"] = { fg = colors.light_blue }
	groups["@variable"] = { fg = colors.white }
	groups["@variable.parameter"] = { fg = colors.yellow }
	groups["@variable.member"] = { fg = colors.green }
	groups["@annotation"] = { link = "PreProc" }
	groups["@attribute"] = { link = "PreProc" }
	groups["@attribute.builtin"] = { link = "Special" }
	groups["@boolean"] = { link = "Boolean" }
	groups["@character"] = { link = "Character" }
	groups["@character.printf"] = { link = "SpecialChar" }
	groups["@character.special"] = { link = "SpecialChar" }
	groups["@comment"] = { link = "Comment" }
	groups["@comment.error"] = { fg = colors.red }
	groups["@comment.hint"] = { fg = colors.bright_green }
	groups["@comment.info"] = { fg = colors.cyan }
	groups["@comment.note"] = { fg = colors.bright_green }
	groups["@comment.todo"] = { fg = colors.blue }
	groups["@comment.warning"] = { fg = colors.yellow }
	groups["@constant"] = { link = "Constant" }
	groups["@constant.builtin"] = { link = "Special" }
	groups["@constant.macro"] = { link = "Define" }
	groups["@constructor"] = { fg = colors.bright_magenta }
	groups["@constructor.tsx"] = { fg = colors.blue }
	groups["DiffChange"] = { bg = colors.bright_black }
	groups["@diff.delta"] = { link = "DiffChange" }
	groups["DiffDelete"] = { bg = colors.bright_red }
	groups["@diff.minus"] = { link = "DiffDelete" }
	groups["@DiffAdd"] = { bg = colors.bright_green }
	groups["@diff.plus"] = { link = "DiffAdd" }
	groups["@function"] = { link = "Function" }
	groups["@function.builtin"] = { link = "Special" }
	groups["@function.call"] = { link = "@function" }
	groups["@function.macro"] = { link = "Macro" }
	groups["@function.method"] = { link = "Function" }
	groups["@function.method"] = { link = "@function.method" }
	groups["@label"] = { fg = colors.blue }
	groups["@property"] = { fg = colors.green }

	groups["@markup.link"] = { link = "@type" }
end

return M
