" asciidoc.vim -- asciidoc plugin
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-10-21
" @Last Modified: Wed 01. Dec 2010 20:42:35 +0100 CET
" @Revision     : 0.5
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Adds support for ctags - works best in combination with taglist plugin
" @Usage        : copy to ftplugin/asciidoc.vim
" @TODO         :
" @CHANGES      :

compiler asciidoc

setlocal comments+=://
setlocal formatoptions=tcrqn
setlocal shiftwidth=2

nnoremap <buffer> <leader>vp :!xdg-open "%:p:r.pdf" 2> /dev/null & disown<CR>
nnoremap <buffer> <leader>vh :!xdg-open "%:p:r.html" 2> /dev/null & disown<CR>
nnoremap <buffer> <leader>hh yypVr

if &cp || exists("g:loaded_asciidoc")
	finish
endif
let g:loaded_asciidoc = 1

if !exists('AsciidocBrowser_Show_Blocks')
	let AsciidocBrowser_Show_Blocks = 1
endif

if !exists('Tlist_Ctags_Cmd')
	finish
endif

" ****************** Options *******************************************
" How many title levels are supported, default is 3.
if !exists('AsciidocBrowser_Title_Level')
	let AsciidocBrowser_Title_Level = 3
endif

" When this file is reloaded, only load ABrowser_Ctags_Cmd once.
if !exists('ABrowser_Ctags_Cmd')
	let ABrowser_Ctags_Cmd = Tlist_Ctags_Cmd
endif

" Asciidoc tag definition start.
let s:ABrowser_Config = ' --langdef=asciidoc --langmap=asciidoc:.adoc '

" Title tag definition
let s:ABrowser_Config .= '--regex-asciidoc="/(^={1}\s+([^=]*)|([^=]*)\s+={1}$)/\2/c,content/" '
let s:ABrowser_Config .= '--regex-asciidoc="/(^={2}\s+([^=]*)|([^=]*)\s+={2}$)/= \2/c,content/" '
if (AsciidocBrowser_Title_Level >= 2)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={3}\s+([^=]*)|([^=]*)\s+={3}$)/== \2/c,content/" '
endif
if (AsciidocBrowser_Title_Level >= 3)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={4}\s+([^=]*)|([^=]*)\s+={4}$)/=== \2/c,content/" '
endif
if (AsciidocBrowser_Title_Level >= 4)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={5}\s+([^=]*)|([^=]*)\s+={5}$)/==== \2/c,content/" '
endif

" Blocks
if AsciidocBrowser_Show_Blocks == 1
	let s:ABrowser_Config .= '--regex-asciidoc="/^\.(.+)$/. \1/c,content/" '
endif

" Macros
let s:ABrowser_Config .= '--regex-asciidoc="/([a-z]+)::([^[]*)\[/\1 \2/m,macros/" '

" Admonition Paragraphs
let s:ABrowser_Config .= '--regex-asciidoc="/^(TIP|NOTE|IMPORTANT|WARNING|CAUTION):\s*(.*)$/\1 \2/a,admonition/" '
let s:ABrowser_Config .= '--regex-asciidoc="/^\[(TIP|NOTE|IMPORTANT|WARNING|CAUTION)\]$/\[\1\]/a,admonition/" '

" Lists
let s:ABrowser_Config .= '--regex-asciidoc="/^\[glossary\]$/Glossary/l,lists/" '
let s:ABrowser_Config .= '--regex-asciidoc="/^\[qanda\]$/Questions and Answers/l,lists/" '
let s:ABrowser_Config .= '--regex-asciidoc="/^\[bibliography\]$/Bibliography/l,lists/" '

" Footnotes
let s:ABrowser_Config .= '--regex-asciidoc="/footnote:\[([^[]*)\]/\1/f,footnotes/" '
let s:ABrowser_Config .= '--regex-asciidoc="/indexterm:\[([^[]*)\]/\1/i,indexes/" '

" Pass parameters to taglist
let tlist_asciidoc_settings = 'asciidoc;c:content;l:lists;a:admonition;m:macros;f:footnotes;i:indexes'
let Tlist_Ctags_Cmd = ABrowser_Ctags_Cmd . s:ABrowser_Config
