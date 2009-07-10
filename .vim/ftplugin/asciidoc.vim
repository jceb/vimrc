" asciidoc.vim -- asciidoc plugin
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-10-21
" @Last Modified: Wed 23. May 2007 10:28:43 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_asciidoc")
    finish
endif
let b:loaded_asciidoc = 1

compiler asciidoc

setlocal comments=://
setlocal formatoptions=tcrqn
setlocal shiftwidth=2

nnoremap <leader>vp :!xpdf "%:p:r.pdf" 2> /dev/null & disown<CR>
nnoremap <leader>vh :!x-www-browser "%:p:r.html" 2> /dev/null & disown<CR>
nnoremap <leader>hh yypVr
