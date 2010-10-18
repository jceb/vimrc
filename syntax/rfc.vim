
highlight rfcBold term=bold cterm=bold gui=bold
highlight rfcEmphasize term=italic ctermfg=darkgreen guifg=darkgreen gui=italic
highlight rfcMonospace term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcSubscript term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcSuperscript term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcAdmonitionNote term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
highlight rfcAdmonitionWarn term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
highlight rfcTodo term=reverse ctermfg=black ctermbg=yellow guifg=black guibg=yellow
highlight rfcReference term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcFootnote term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcDefinition term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight rfcQuestion term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight rfcGlossary term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight rfcMacro term=standout ctermfg=darkred guifg=darkred
highlight rfcSpecialChar term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcSource term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcPassthrough term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcInclude term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcBackslash ctermfg=darkmagenta guifg=darkmagenta
highlight rfcReplacements term=standout ctermfg=darkcyan guifg=darkcyan
highlight rfcBiblio term=bold ctermfg=cyan guifg=darkcyan gui=bold
highlight rfcRevisionInfo term=standout ctermfg=blue guifg=darkblue gui=bold

"Attributes
highlight rfcAttributeEntry term=standout ctermfg=darkgreen guifg=darkgreen
highlight rfcAttributeList term=standout ctermfg=darkgreen guifg=darkgreen
highlight rfcAttributeRef term=standout ctermfg=darkgreen guifg=darkgreen

"Lists
highlight rfcListBullet ctermfg=darkcyan guifg=darkcyan gui=bold
highlight rfcListContinuation ctermfg=darkcyan guifg=darkcyan gui=bold
highlight rfcListNumber ctermfg=darkcyan guifg=darkcyan gui=bold

"Sections
highlight rfcSect0 term=underline ctermfg=darkmagenta cterm=bold,underline guifg=darkmagenta gui=bold,underline
highlight rfcSect1 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcSect2 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcSect3 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcSect4 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcSect0Old term=underline ctermfg=darkmagenta cterm=bold guifg=darkmagenta gui=bold
highlight rfcSect1Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcSect2Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcSect3Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight rfcSect4Old term=underline ctermfg=darkmagenta guifg=darkmagenta

"Links
highlight rfcEmail term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcLink term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcURI term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight rfcURITitle term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline

"Blocks
highlight rfcBlockTitle term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight rfcExampleBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcListingBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcLiteralBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcLiteralParagraph term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcFilterBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcQuoteBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight rfcSidebarBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow

"Tables
highlight rfcTable term=standout ctermfg=darkyellow guifg=darkyellow

"Comments
highlight rfcCommentBlock term=standout ctermfg=darkblue guifg=darkblue
highlight rfcCommentLine term=standout ctermfg=darkblue guifg=darkblue

"Macros
"highlight link rfcAnchorMacro Macro
highlight rfcAnchorMacro term=standout ctermfg=darkred guifg=darkred
highlight link rfcIndexTerm Macro
"highlight link rfcMacro Macro
"highlight link rfcMacroAttributes Label
highlight rfcMacroAttributes term=underline ctermfg=darkyellow cterm=underline guifg=darkyellow gui=underline
"highlight link rfcRefMacro Macro
highlight rfcRefMacro term=standout ctermfg=darkred guifg=darkred

syn match rfcBold "\[Page\s\+\d\+\]\s*$"
"syn match rfcEmphasize "^\d\+\..*$"


syn match rfcSect0 "^\s*\(\d\+\.\)\{1}\s\+.*$" skipwhite
syn match rfcSect1 "^\s*\(\d\+\.\)\{2}\s\+.*$" skipwhite
syn match rfcSect2 "^\s*\(\d\+\.\)\{3}\s\+.*$" skipwhite
syn match rfcSect3 "^\s*\(\d\+\.\)\{4}\s\+.*$" skipwhite
syn match rfcSect4 "^\s*\(\d\+\.\)\{5}\s\+.*$" skipwhite
