local M = {}

local mix = require("termcol/util").mix

function M.get(colors, groups)
	groups["@module.rust"] = { link = "PreProc" }
	groups["@keyword.import.rust"] = { link = "PreProc" }
	groups["@lsp.type.namespace.rust"] = { link = "PreProc" }
	groups["@function.macro.rust"] = { link = "PreProc" }
	groups["@lsp.type.macro.rust"] = { link = "PreProc" }
	groups["@keyword.modifier.rust"] = { link = "@keyword" }
	groups["@lsp.type.keyword.rust"] = { link = "@keyword" }
	groups["@keyword.rust"] = { link = "@keyword" }
	groups["@keyword.function.rust"] = { link = "@keyword.function" }
	groups["@lsp.type.interface.rust"] = { link = "@lsp.type.interface" }
	groups["@type.builtin.rust"] = { link = "@type.builtin" }
	groups["@lsp.typemod.enum.defaultLibrary.rust"] = { link = "@type.builtin" }
	groups["@operator.rust"] = { link = "@operator" }
	groups["@variable.parameter.rust"] = { link = "@variable.parameter" }
	groups["@lsp.type.parameter.rust"] = { link = "@variable.parameter" }
	groups["@variable.member.rust"] = { link = "@variable.member" }
	groups["@lsp.typemod.method.defaultLibrary.rust"] = {
		fg = mix(colors.blue, colors.black, 0.2)
	}
	groups["@lsp.type.property.rust"] = { link = "@property" }
	groups["@lsp.type.formatSpecifier.rust"] = { link = "@markup.list" }
end

return M
