" asciidoc.vim -- asciidoc plugin
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-10-21
" @Last Modified: Mon 03. May 2010 23:07:48 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

compiler asciidoc

setlocal comments=://
setlocal formatoptions=tcrqn
setlocal shiftwidth=2

nnoremap <buffer> <leader>vp :!xpdf "%:p:r.pdf" 2> /dev/null & disown<CR>
nnoremap <buffer> <leader>vh :!x-www-browser "%:p:r.html" 2> /dev/null & disown<CR>
nnoremap <buffer> <leader>hh yypVr

if &cp || exists("g:loaded_asciidoc")
	finish
endif
let g:loaded_asciidoc = 1

if !exists('Tlist_Ctags_Cmd')
	finish
endif

" ****************** Options *******************************************
"How many title level to support, default is 3.
if !exists('AsciidocBrowser_Title_Level')
	let AsciidocBrowser_Title_Level = 3
endif

"When this file reload, only load ABrowser_Ctags_Cmd once.
if !exists('ABrowser_Ctags_Cmd')
	let ABrowser_Ctags_Cmd = Tlist_Ctags_Cmd
endif

"Txt tag definition start.
let s:ABrowser_Config = ' --langdef=asciidoc --langmap=asciidoc:.adoc '

"Title tag definition
let s:ABrowser_Config .= '--regex-asciidoc="/(^={1} ([^=]*)|([^=]*) ={1}$)/\2/c,content/" '
let s:ABrowser_Config .= '--regex-asciidoc="/(^={2} ([^=]*)|([^=]*) ={2}$)/. \2/c,content/" '
if (AsciidocBrowser_Title_Level >= 2)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={3} ([^=]*)|([^=]*) ={3}$)/.. \2/c,content/" '
endif
if (AsciidocBrowser_Title_Level >= 3)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={4} ([^=]*)|([^=]*) ={4}$)/... \2/c,content/" '
endif
if (AsciidocBrowser_Title_Level >= 4)
	let s:ABrowser_Config .= '--regex-asciidoc="/(^={5} ([^=]*)|([^=]*) ={5}$)/.... \2/c,content/" '
endif

" TODO
" Add references
" Add tables
" Add figures
" ...

"Pass parameters to taglist
let tlist_asciidoc_settings = 'asciidoc;c:content;f:figures;t:tables'
let Tlist_Ctags_Cmd = ABrowser_Ctags_Cmd . s:ABrowser_Config
