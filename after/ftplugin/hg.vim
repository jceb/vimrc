" hg.vim -- a collection of useful functions for hg commit files
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-02-26
" @Last Modified: Sun 28. Sep 2008 11:36:19 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_hg")
    finish
endif
let b:loaded_hg = 1

nnoremap <leader>di :call <SID>diff(0)<CR>
nnoremap <leader>diw :call <SID>diff(1)<CR>

function! s:diff(toBuffer)
    exec 'normal "zyiW'
    let filename=getreg('z')
    if filename != ''
        if a:toBuffer != 0
            vsplit
            exec 'normal l'
            ene
            set filetype=diff buftype=nofile
            silent cd $PWD
            exec '.!hg diff '.filename
            silent cd -
        else
            silent cd $PWD
            exec '!hg diff '.filename
            silent cd -
        endif
    endif
    unlet filename
endfun
