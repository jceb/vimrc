" Vim syntax file
" Language: Asciidoc text document
" Maintainer: Dag Wieers <dag@wieers.com> (merged wih Stuart Rackham's
"             upstream asciidoc.vim script).
" URL: http://www.methods.co.nz/asciidoc/
" License: GPL (http://www.gnu.org)
" Last Change:»·$Date: 2007/07/18 16:11:12 $
" $Revision$

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn sync linebreaks=1

syn match asciidocCallout "<\d\d\?>"
syn match asciidocBackslash "\\"
syn match asciidocLineBreak "[ \t]+$"
syn match asciidocRuler "^''''\+$"

" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn region asciidocMonospace start="\(^\|[ \t(\[.,\-]\)\@<=+\([)]\)\@!" end="\(+\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocMonospace start="\(^\|[ \t(\[.,\-]\)\@<=`\([)]\)\@!" end="\(`\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocMonospace start="++\S" end="\(++\|^$\)"
"syn match asciidocMonospace "+[^+]\++"
"syn match asciidocMonospace "`[^`]\+`"
syn region asciidocEmphasize start="\(^\|[ \t(\[.,\-]\)\@<=_\([)]\)\@!" end="\(_\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocEmphasize start="\(^\|[ \t(\[.,\-]\)\@<='\([)]\)\@!" end="\('\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocEmphasize start="__\S" end="\(__\|^$\)"
"syn match asciidocEmphasize "_[^_]\+_"
"FIXME: Emphasizing using single quotes is prone to failure, so we disable it.
"syn region asciidocEmphasize start="\'[^\']"  end="\'\([^\']\|$\)"
"syn match asciidocEmphasize "'[^']\+'"
syn region asciidocBold start="\(^\|[ \t(\[.,\-]\)\@<=\*\([ )]\)\@!" end="\(\*\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocBold start="\*\*\S" end="\(\*\*\|^$\)"
"syn match asciidocBold "\*[^*]\+\*"
syn region asciidocQuoted start="\(^\|[ \t(\[.,\-]\)\@<=``\([ )]\)\@!" end="\(''\([ \t)\],.?!;:\-]\|$\)\@=\|^$\)"
syn region asciidocSubscript start="\~\S" end="\(\~\|^$\)"
syn region asciidocSuperscript start="\^\S" end="\(\^\|^$\)"
"syn match asciidocPassthrough "\$\$.\+\$\$"
"syn match asciidocPassthrough "+++[^+]\++++"
syn region asciidocPassthrough start="\(^\|\W\)\@<=\$\$\S" end="\(\$\$\(\W\|$\)\@=\|^$\)"
syn region asciidocPassthrough start="\(^\|\W\)\@<=+++\S" end="\(+++\(\W\|$\)\@=\|^$\)"

syn match asciidocRevisionInfo "\$\w\+\(:\s.\+\s\)\?\$"

syn match asciidocBiblio "^\s*+\s\+"
syn match asciidocSource "^\s\s*\$\s\+.\+$"
syn keyword asciidocTodo TODO FIXME XXX ZZZ contained
"syn match asciidocReplacements "[\s^]\(\(C\)\|\(TM\)\|\(R\)\|--\|\.\.\.\)[\s$]"
syn match asciidocEmail "\S\+@\S\+\(.\S+\)*"
syn match asciidocSpecialChar "{amp}\w+;"
syn match asciidocAdmonitionNote "^\(NOTE\|TIP\):\(\s\+.*\)\@="
syn match asciidocAdmonitionWarn "^\(CAUTION\|IMPORTANT\|WARNING\):\(\s\+.*\)\@="
syn match asciidocAdmonitionNote "^\[\(NOTE\|TIP\)\]\s*$"
syn match asciidocAdmonitionWarn "^\[\(CAUTION\|IMPORTANT\|WARNING\)\]\s*$"
syn region asciidocVLabel start="^\s*" end="\S\(::\|;;\|:-\|??\)$" oneline
syn region asciidocHLabel start="^\s*" end="\S\(::\|;;\)\s\+" oneline

"Attributes
syn region asciidocAttributeEntry start="^:\a" end=":\(\s\|$\)" oneline
"syn region asciidocAttributeEntry start="^:" end=":\s\+$" oneline
syn match asciidocAttributeList "^\[[^[ \t].*\]$"
"syn region asciidocAttributeList start="^\[" end="\]\s*$" oneline
syn match asciidocAttributeRef "{\(\w\|-\)\+}"

"Macros
syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start="<<\w\(\w\|-\)*,\?" end=">>"
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start="\[\[\(\w\|-\)\+,\?" end="\]\]"
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start="\[\[\[\(\w\|-\)\+" end="\]\]\]"
syn region asciidocMacroAttributes matchgroup=asciidocMacro start="\w\(\w\|-\)*:\S\{-}\[" skip="\\\]" end="\]"
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start="(((?" end=")))\?"
syn match asciidocMacroAttributes "\w\(\w\|-\)*:\S\{-}\[\]"
"syn region asciidocMacroAttributes matchgroup=asciidocMacro start="\w\(\w\|-\)*:\S\{-}\[" end="\]"
"syn match asciidocMacro "\[\[.*\]\]"
"syn match asciidocMacro "((.*))"
"syn match asciidocReference "<<\w\+>>"
"syn match asciidocReference "<<\w\+,.\+>>"

"Lists
syn match asciidocListBlockDelimiter "^--$"
syn match asciidocListBullet "^\s*[*+-]\s"
syn match asciidocListContinuation "^+$"
"syn match asciidocListNumber "^\s*\d\+[.)]\s"
syn match asciidocListNumber "^\s*\(\d*\.\.\?\|\l\?)\|\w\.\)\s\+"

"Sections
syn region asciidocSect0 start="^=\s\+\S" end="$" oneline
syn region asciidocSect1 start="^==\s\+\S" end="$" oneline 
syn region asciidocSect2 start="^===\s\+\S" end="$" oneline
syn region asciidocSect3 start="^====\s\+\S" end="$" oneline
syn region asciidocSect4 start="^=====\s\+\S" end="$" oneline

"FIXME: It is impossible to distinguish underlined titles from block delimiters
"       because we cannot calculate length in VIM syntax
syn match asciidocSect0Old "^[^. +/[].*[^.:]\n==\+$"
syn match asciidocSect1Old "^[^. +/[].*[^.:]\n--\+$"
syn match asciidocSect2Old "^[^. +/[].*[^.:]\n\~\~\+$"
syn match asciidocSect3Old "^[^. +/[].*[^.:]\n^^\+$"
syn match asciidocSect4Old "^[^. +/[].*[^.:]\n++\+$"

syn region asciidocDefinition start="\S" end="::\s*$" oneline
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

"Blocks
syn match asciidocBlockTitle "^\.[^. \t].*[^-~_]$"
"syn region asciidocBlockTitle start="^\.\S.\+" end="$" oneline
"syn region asciidocExampleBlock start="^====\+$" end="^====\+$"
syn match asciidocExampleBlockDelimiter "^====\+$"
syn region asciidocFilterBlock start="^\w\+\~\~\~\~\+$" end="^\w\+\~\~\~\~\+$"
syn region asciidocListingBlock start="^----\+$" end="^----\+$" contains=asciidocCallout
syn region asciidocLiteralBlock start="^\.\.\.\.\+$" end="^\.\.\.\.\+$" contains=asciidocCallout
syn region asciidocPassthroughBlock start="^++++\+$" end="^++++\+$"
"syn region asciidocQuoteBlock start="^____\+$" end="^____\+$"
syn match asciidocQuoteBlockDelimiter "^____\+$"
"syn region asciidocSidebarBlock start="^\*\*\*\*\+$" end="^\*\*\*\*\+$"
syn match asciidocSidebarBlockDelimiter "^\*\*\*\*\+$"

" FIXME: The tricky part is not triggering on indented list items that are also
" preceeded by blank line, handles only bulleted items (see 'Limitations' above
" for workarounds).
syn region asciidocLiteralParagraph start="^\n[ \t]\+\(\([^-*. \t] \)\|\(\S\S\)\)" end="\(^+\?\s*$\)\@="

"Tables
syn region asciidocTable start="^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$" end="^$"

"Comments
syn match asciidocCommentLine "^\s*//\([^/].*\|\)$" contains=asciidocToDo
syn region asciidocCommentBlock start="^////\+\s*$" end="^////\+\s*$" contains=asciidocTodo

"Styles
highlight asciidocBold term=bold cterm=bold gui=bold
highlight asciidocEmphasize term=italic ctermfg=darkgreen guifg=darkgreen gui=italic
highlight asciidocMonospace term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocSubscript term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocSuperscript term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocAdmonitionNote term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
highlight asciidocAdmonitionWarn term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
highlight asciidocTodo term=reverse ctermfg=black ctermbg=yellow guifg=black guibg=yellow
highlight asciidocReference term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocFootnote term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocDefinition term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocQuestion term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocGlossary term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocMacro term=standout ctermfg=darkred guifg=darkred
highlight asciidocSpecialChar term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocSource term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocPassthrough term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocInclude term=underline ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocBackslash ctermfg=darkmagenta guifg=darkmagenta
highlight asciidocReplacements term=standout ctermfg=darkcyan guifg=darkcyan
highlight asciidocBiblio term=bold ctermfg=cyan guifg=darkcyan gui=bold
highlight asciidocRevisionInfo term=standout ctermfg=blue guifg=darkblue gui=bold

"Attributes
highlight asciidocAttributeEntry term=standout ctermfg=darkgreen guifg=darkgreen
highlight asciidocAttributeList term=standout ctermfg=darkgreen guifg=darkgreen
highlight asciidocAttributeRef term=standout ctermfg=darkgreen guifg=darkgreen

"Lists
highlight asciidocListBullet ctermfg=darkcyan guifg=darkcyan gui=bold
highlight asciidocListContinuation ctermfg=darkcyan guifg=darkcyan gui=bold
highlight asciidocListNumber ctermfg=darkcyan guifg=darkcyan gui=bold

"Sections
highlight asciidocSect0 term=underline ctermfg=darkmagenta cterm=bold,underline guifg=darkmagenta gui=bold,underline
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
highlight asciidocEmail term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocLink term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocURI term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline
highlight asciidocURITitle term=underline ctermfg=darkmagenta cterm=underline guifg=darkmagenta gui=underline

"Blocks
highlight asciidocBlockTitle term=underline ctermfg=darkgreen cterm=underline guifg=darkgreen gui=underline
highlight asciidocExampleBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocListingBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocLiteralBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocLiteralParagraph term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocFilterBlock term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocQuoteBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow
highlight asciidocSidebarBlockDelimiter term=standout ctermfg=darkyellow guifg=darkyellow

"Tables
highlight asciidocTable term=standout ctermfg=darkyellow guifg=darkyellow

"Comments
highlight asciidocCommentBlock term=standout ctermfg=darkblue guifg=darkblue
highlight asciidocCommentLine term=standout ctermfg=darkblue guifg=darkblue

"Macros
"highlight link asciidocAnchorMacro Macro
highlight asciidocAnchorMacro term=standout ctermfg=darkred guifg=darkred
highlight link asciidocIndexTerm Macro
"highlight link asciidocMacro Macro
"highlight link asciidocMacroAttributes Label
highlight asciidocMacroAttributes term=underline ctermfg=darkyellow cterm=underline guifg=darkyellow gui=underline
"highlight link asciidocRefMacro Macro
highlight asciidocRefMacro term=standout ctermfg=darkred guifg=darkred

"Other
highlight link asciidocCallout Label
highlight link asciidocRuler Type
highlight link asciidocLineBreak Special
highlight link asciidocVLabel Label
highlight link asciidocHLabel Label
highlight link asciidocQuoted Label

let b:current_syntax = "asciidoc"

"Show tab and trailing characters
set listchars=tab:»·,trail:·
set list

"
"set textwidth=78 formatoptions=tcqn autoindent
set formatoptions=tcqn autoindent

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
