" Vim syntax file
"AUTHOR:   Greg Sexton <gregsexton@gmail.com>
"WEBSITE:  https://github.com/gregsexton/VimCalc
"VERSION:  1.0, for Vim 7.0+
"LICENSE:  Same terms as Vim itself (see :help license).

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syntax keyword vcalcAns ans
syntax keyword vcalcE   e
syntax keyword vcalcPi  pi
syntax keyword vcalcPhi phi

syntax keyword vcalcLet let

syntax keyword vcalcFuncs abs acos asin atan atan2 ceil choose cos cosh deg exp floor hypot inv ldexp lg ln log log10 max min nrt perms pow rad rand round sin sinh sqrt tan tanh

syntax match vcalcDirectives ":hex\|:oct\|:dec"

syntax match vcalcOps "\*\*=\|%=\|/=\|\*=\|-=\|+=\|<<\|>>\|\*\*\|=\|!\|%\|/\|\*\|-\|+"
syntax match vcalcDelim "(\|)"

syntax match vcalcDecNum "[0-9]\+\(\.[0-9]\+\)\?\(e[+-]\?[0-9]\+\)\?"
syntax match vcalcHexNum "0x[0-9a-fA-F]\+"
syntax match vcalcOctNum "0[0-7]\+"

syntax match vcalcSynErr "^Syntax error: .*"
syntax match vcalcParErr "^Parse error: .*"

if g:VCalc_Prompt != ''
    silent execute "syn match vcalcPrompt '" . g:VCalc_Prompt . "'"
    hi def link vcalcPrompt Type
endif

if version >= 600
	command -nargs=+ HiLink highlight default link <args>
else
	command -nargs=+ HiLink highlight         link <args>
endif

"Special Symbols
HiLink vcalcAns         vcalcSymbol
HiLink vcalcE           vcalcSymbol
HiLink vcalcPi          vcalcSymbol
HiLink vcalcPhi         vcalcSymbol
HiLink vcalcSymbol      Constant

"Keywords
HiLink vcalcLet         vcalcKeyword
HiLink vcalcKeyword     Keyword

"Functions
HiLink vcalcFuncs       Function

"Operators
HiLink vcalcOps         Operator

"Delimiters
HiLink vcalcDelim       Delimiter

"Directives
HiLink vcalcDirectives  Special

"Numbers
HiLink vcalcDecNum      vcalcNumber
HiLink vcalcHexNum      vcalcNumber
HiLink vcalcOctNum      vcalcNumber
HiLink vcalcNumber      Number

"Errors
HiLink vcalcSynErr      vcalcError
HiLink vcalcParErr      vcalcError
HiLink vcalcError       Error

delcommand HiLink

let b:current_syntax = "vimcalc"
