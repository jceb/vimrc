" mkd.vim -- Markdown plugin
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2006-10-21
" @Last Modified: Thu 15. Mar 2007 21:40:28 +0100 CET
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_mkd")
    finish
endif
let b:loaded_mkd = 1

compiler mkd

nnoremap <leader>vp :!xpdf "%:p:r.pdf" 2> /dev/null & disown<CR>
nnoremap <leader>vh :!x-www-browser "%:p:r.html" 2> /dev/null & disown<CR>
