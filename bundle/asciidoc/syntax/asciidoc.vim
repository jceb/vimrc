" Vim syntax file
" Language: Asciidoc text document
" Maintainer: Dag Wieers <dag@wieers.com> (merged wih Stuart Rackham's
"             upstream asciidoc.vim script).
" URL: http://www.methods.co.nz/asciidoc/
" License: GPL (http://www.gnu.org)
" Remarks: Vim 6 or greater
" Limitations: See 'Appendix E: Vim Syntax Highlighter' in the AsciiDoc 'User
"               Guide'.
" Last Change: $Date: 2007/07/18 16:11:12 $
" $Revision$

if exists("b:current_syntax")
  finish
endif

syn clear
syn sync fromstart
syn sync linebreaks=1

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO FIXME CHECK TEST XXX ZZZ DEPRECATED contained
syn match asciidocBackslash /\\/
syn region asciidocIdMarker start=/^\$Id:\s/ end=/\s\$$/
syn match asciidocCallout /\\\@<!<\d\{1,2}>/
syn match asciidocListBlockDelimiter /^--$/
syn match asciidocLineBreak /[ \t]+$/
syn match asciidocRuler /^'\{3,}$/
syn match asciidocPagebreak /^<\{3,}$/
syn match asciidocEntityRef /\\\@<!&[#a-zA-Z]\S\{-};/
" FIXME: The tricky part is not triggering on indented list items that are also
" preceeded by blank line, handles only bulleted items (see 'Limitations' above
" for workarounds).
"syn region asciidocLiteralParagraph start="^\n[ \t]\+\(\([^-*. \t] \)\|\(\S\S\)\)" end="\(^+\?\s*$\)\@="
syn region asciidocLiteralParagraph start=/^\s\+\S\+/ end=/\(^+\?\s*$\)\@=/
syn match asciidocURL /\\\@<!\<\(http\|https\|ftp\|file\|irc\):\/\/[^| \t]*\(\w\|\/\)/
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/
syn match asciidocAttributeRef /\\\@<!{\w\(\w\|-\)*\([=!@#$%?:].*\)\?}/


" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn match asciidocQuotedSubscript /\\\@<!\~\S\_.\{-}\(\~\|\n\s*\n\)/
syn match asciidocQuotedSuperscript /\\\@<!\^\S\_.\{-}\(\^\|\n\s*\n\)/

syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=+\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(+\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=`\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(`\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedMonospaced /[\\+]\@<!++\S\_.\{-}\(++\|\n\s*\n\)/

syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<=_\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(_\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<='\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedEmphasized /\\\@<!__\S\_.\{-}\(__\|\n\s*\n\)/

syn match asciidocQuotedBold /\(^\|[| \t([.,=\-\]]\)\@<=\*\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(\*\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedBold /\\\@<!\*\*\S\_.\{-}\(\*\*\|\n\s*\n\)/

" Don't allow ` in single quoted (a kludge to stop confusion with `monospaced`).
syn match asciidocQuotedSingleQuoted /\(^\|[| \t([.,=\-]\)\@<=`\([ )\n\t]\)\@!\([^`]\|\n\(\s*\n\)\@!\)\{-}[^` \t]\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocQuotedDoubleQuoted /\(^\|[| \t([.,=\-]\)\@<=``\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(''\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocDoubleDollarPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=\$\$..\{-}\(\$\$\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/
syn match asciidocTriplePlusPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=+++..\{-}\(+++\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/

syn region asciidocTable_OLD start=/^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$/ end=/^$/
syn match asciidocBlockTitle /^\.[^. \t].*[^-~_]$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocTitleUnderline /[-=~^+]\{2,}$/ transparent contained contains=NONE
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{2,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline

syn match asciidocAttributeList /^\[[^[ \t].*\]$/
syn match asciidocQuoteBlockDelimiter /^_\{4,}$/
syn match asciidocExampleBlockDelimiter /^=\{4,}$/
syn match asciidocSidebarDelimiter /^*\{4,}$/

syn match asciidocAdmonitionNote /^\(NOTE\|TIP\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionNote /^\[\(NOTE\|TIP\)\]\s*$/
syn match asciidocAdmonitionWarn /^\(CAUTION\|IMPORTANT\|WARNING\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionWarn /^\[\(CAUTION\|IMPORTANT\|WARNING\)\]\s*$/

" See http://vimdoc.sourceforge.net/htmldoc/usr_44.html for excluding region
" contents from highlighting.
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?|/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock matchgroup=asciidocTableDelimiter start=/^|=\{3,}$/ end=/^|=\{3,}$/ keepend contains=ALL
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?!/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock2 matchgroup=asciidocTableDelimiter2 start=/^!=\{3,}$/ end=/^!=\{3,}$/ keepend contains=ALL

syn match asciidocListContinuation /^+$/
syn region asciidocLiteralBlock start=/^\.\{4,}$/ end=/^\.\{4,}$/ contains=asciidocCallout keepend
syn region asciidocListingBlock start=/^-\{4,}$/ end=/^-\{4,}$/ contains=asciidocCallout keepend
syn region asciidocCommentBlock start="^/\{4,}$" end="^/\{4,}$" contains=asciidocToDo
syn region asciidocPassthroughBlock start="^+\{4,}$" end="^+\{4,}$"

" Allowing leading \w characters in the filter delimiter is to accomodate
" the pre version 8.2.7 syntax and may be removed in future releases.
syn region asciidocFilterBlock start=/^\w*\~\{4,}$/ end=/^\w*\~\{4,}$/

syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start=/\\\@<!<<"\{-}\w\(\w\|-\)*"\?,\?/ end=/\(>>\)\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{2}\(\w\|-\)\+,\?/ end=/\]\{2}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{3}\(\w\|-\)\+/ end=/\]\{3}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/[\\0-9a-zA-Z]\@<!\w\(\w\|-\)*:\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start=/\\\@<!(\{2,3}/ end=/)\{2,3}/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAttributeMacro start=/\({\(\w\|-\)\+}\)\@<=\[/ skip=/\\\]/ end=/\]/ keepend

syn match asciidocCommentLine "^//\([^/].*\|\)$" contains=asciidocToDo

syn region asciidocAttributeEntry start=/^:\a/ end=/:\(\s\|$\)/ oneline

" Lists.
syn match asciidocListBullet /^\s*\zs\(-\|\*\{1,5}\)\ze\s/
syn match asciidocListNumber /^\s*\zs\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\ze\s\+/
syn region asciidocListLabel start=/^\s*/ end=/\(:\{2,4}\|;;\)$/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash keepend
" DEPRECATED: Horizontal label.
syn region asciidocHLabel start=/^\s*/ end=/\(::\|;;\)\(\s\+\|\\$\)/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes keepend
" Starts with any of the above.
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^+\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList

"====================== OLD STUFF ============================

"Sections
syn region asciidocSect0 start=/^=\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect1 start=/^==\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect2 start=/^===\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect3 start=/^====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect4 start=/^=====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef

"FIXME: It is impossible to distinguish underlined titles from block delimiters
"       because we cannot calculate length in VIM syntax
syn match asciidocSect0Old /^[^. +/[].*[^.:]\n==\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect1Old /^[^. +/[].*[^.:]\n--\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect2Old /^[^. +/[].*[^.:]\n\~\~\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect3Old /^[^. +/[].*[^.:]\n^^\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect4Old /^[^. +/[].*[^.:]\n++\+$/ contains=asciidocQuoted.*,asciidocAttributeRef

"Others
syn match asciidocReplacements "[\s^]\(\(C\)\|\(TM\)\|\(R\)\|--\|\.\.\.\)[\s$]"
syn match asciidocRevisionInfo "\$\w\+\(:\s.\+\s\)\?\$"
syn match asciidocBiblio "^\s*+\s\+"
syn match asciidocSource "^\s\s*\$\s\+.\+$"
"syn match asciidocSpecialChar "{amp}\w+;"
syn region asciidocQuestion start="\S" end="??\s*$" oneline
syn region asciidocGlossary start="\S" end=":-\s*$" oneline
"syn match asciidocFootnote "footnote:\[.*\]"
"syn match asciidocLink "link:.*\[.*\]"
"syn match asciidocURI "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[\]"
"syn match asciidocURITitle "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[.*\]"
"syn match asciidocInclude "include::.*\[.*\]"
"syn match asciidocInclude "include1::.*\[.*\]"
"syn match asciidocInclude "image:.*\[.*\]"
"syn match asciidocInclude "image::.*\[.*\]"
"syn match asciidocInclude "footnote:\[.*\]"
"syn match asciidocInclude "indexterm:\[.*\]"
"syn match asciidocInclude "ifdef::.*\[\]"
"syn match asciidocInclude "ifndef::.*\[\]"
"syn match asciidocInclude "endif::.*\[\]"
"syn match asciidocInclude "eval::\[\]"
"syn match asciidocInclude "sys::\[\]"
"syn match asciidocInclude "sys2::\[\]"

"Styles
highlight asciidocAdmonitionNote term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
highlight asciidocAdmonitionWarn term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
highlight asciidocBackslash ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocBiblio term=bold ctermfg=darkcyan cterm=bold guifg=darkcyan gui=bold
highlight asciidocDoubleDollarPassthrough term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocFootnote term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocGlossary term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocHLabel term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocInclude term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocQuestion term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocQuotedBold term=bold cterm=bold gui=bold
highlight asciidocQuotedDoubleQuoted term=bold ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuotedEmphasized term=bold ctermfg=darkgreen guifg=darkgreen gui=italic
highlight asciidocQuotedMonospaced term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuotedUnconstrainedBold term=bold cterm=bold gui=bold
highlight asciidocQuotedUnconstrainedEmphasized term=bold ctermfg=darkgreen guifg=darkgreen gui=italic
highlight asciidocQuotedUnconstrainedMonospaced term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuotedSingleQuoted term=bold ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuotedSubscript term=bold ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuotedSuperscript term=bold ctermfg=darkyellow guifg=darkyellow
highlight asciidocReference term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocReplacements term=standout ctermfg=darkcyan guifg=darkcyan
highlight asciidocRevisionInfo term=standout ctermfg=blue guifg=darkblue gui=bold
highlight asciidocSource term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocToDo term=reverse ctermfg=black ctermbg=yellow guifg=black guibg=yellow
highlight asciidocTripplePlusPassthrough term=underline ctermfg=darkmagenta guifg=darkmagenta

"Attributes
highlight asciidocAttributeEntry term=standout ctermfg=darkgreen guifg=darkgreen
highlight asciidocAttributeList term=standout ctermfg=darkgreen guifg=darkgreen
highlight link asciidocAttributeMacro Macro
"highlight asciidocAttributeRef term=standout ctermfg=darkgreen cterm=bold guifg=darkgreen gui=bold
highlight asciidocAttributeRef term=standout,underline ctermfg=darkgreen cterm=bold,underline guifg=darkgreen gui=bold,underline

"Lists
highlight asciidocListBlockDelimiter term=bold ctermfg=darkcyan cterm=bold guifg=darkcyan gui=bold
highlight asciidocListBullet term=bold ctermfg=darkcyan cterm=bold guifg=darkcyan gui=bold
highlight asciidocListContinuation term=bold ctermfg=darkcyan cterm=bold guifg=darkcyan gui=bold
highlight asciidocListLabel term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocListNumber term=bold ctermfg=darkcyan cterm=bold guifg=darkcyan gui=bold

"Sections
highlight asciidocSect0 term=bold,underline ctermfg=darkmagenta cterm=bold,underline guifg=darkmagenta gui=bold,underline
highlight asciidocSect1 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocSect2 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocSect3 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocSect4 term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocSect0Old term=underline ctermfg=darkmagenta cterm=bold guifg=darkmagenta gui=bold
highlight asciidocSect1Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocSect2Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocSect3Old term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocSect4Old term=underline ctermfg=darkmagenta guifg=darkmagenta

"Links
highlight asciidocEmail term=underline ctermfg=darkred cterm=underline guifg=darkred gui=underline
highlight asciidocLink term=underline ctermfg=darkred cterm=underline guifg=darkred gui=underline
highlight asciidocOneLineTitle ctermfg=darkyellow guifg=darkyellow gui=underline
highlight asciidocTwoLineTitle ctermfg=darkyellow guifg=darkyellow gui=underline
highlight asciidocURL term=underline ctermfg=darkred cterm=underline guifg=darkred gui=underline

"Blocks
highlight asciidocBlockTitle term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocExampleBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocFilterBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocListingBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocLiteralBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocLiteralParagraph term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuoteBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocSidebarDelimiter term=standout ctermfg=darkyellow guifg=darkyellow

"Tables
highlight link asciidocTableBlock2 NONE
highlight link asciidocTableBlock NONE
highlight asciidocTableDelimiter2 term=standout ctermfg=darkcyan guifg=darkcyan
highlight asciidocTableDelimiter term=standout ctermfg=darkcyan guifg=darkcyan
highlight asciidocTable_OLD term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocTablePrefix2 term=standout ctermfg=darkcyan guifg=darkcyan
highlight asciidocTablePrefix term=standout ctermfg=darkcyan guifg=darkcyan

"Comments
highlight asciidocCommentBlock term=standout ctermfg=darkblue guifg=darkblue
highlight asciidocCommentLine term=standout ctermfg=darkblue guifg=darkblue

"Macros
highlight asciidocAnchorMacro term=standout ctermfg=darkred guifg=darkred
highlight link asciidocIndexTerm Macro
highlight asciidocMacro term=underline ctermfg=darkred cterm=underline guifg=darkred gui=underline
highlight asciidocMacroAttributes term=bold ctermfg=darkyellow guifg=darkyellow
highlight asciidocRefMacro term=standout ctermfg=darkred guifg=darkred

"Other
highlight link asciidocCallout Label
highlight link asciidocEntityRef Special
highlight link asciidocIdMarker Special
highlight link asciidocLineBreak Special
highlight link asciidocPagebreak Type
highlight link asciidocPassthroughBlock Identifier
highlight link asciidocRuler Type

let b:current_syntax = "asciidoc"

"Show tab and trailing characters
set listchars=tab:»·,trail:·
set list

"
"set textwidth=78 formatoptions=tcqn autoindent
set formatoptions=tcqn

if version >= 700
    "Prevent simple numbers at the start of lines to be confused with list items:
    set formatlistpat=^\\s*\\d\\+\\.\\s\\+
endif

set comments=s1:/*,ex:*/,://,b:#,:%,fb:-,fb:*,fb:.,fb:+,fb:>

"Typing "" inserts a pair of quotes (``'') and places the cursor between
"them. Works in both insert and command mode (switching to insert mode):
imap "" ``''<ESC>hi
map "" i""

nnoremap Q gq}

"eof
