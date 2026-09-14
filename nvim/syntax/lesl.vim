" Vim syntax file
" Language: Lesl

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn keyword leslConditional if else
syn keyword leslRepeat for while
syn keyword leslKeyword break continue

let b:currnet_syntax = "lesl"
