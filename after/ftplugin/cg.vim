" cg.vim -- a collection of useful functions for cg commit files
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-02-26
" @Last Modified: Wed 01. Oct 2008 23:24:45 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_cg")
    finish
endif
let b:loaded_cg = 1

nnoremap <leader>di :call s:diff (0)<CR>
nnoremap <leader>diw :call s:diff (1)<CR>

function! s:diff (toBuffer)
    exec 'normal "zyiW'
    let filename=getreg('z')
    if filename != ''
        if a:toBuffer != 0
            vsplit
            exec 'normal l'
            ene
            set filetype=diff buftype=nofile
            silent cd $PWD
            exec '.!unset GIT_INDEX_FILE; unset GIT_DIR; cg diff -- '.filename.'|cat'
            silent cd -
        else
            silent cd $PWD
            exec '!unset GIT_INDEX_FILE; unset GIT_DIR; cg diff -- '.filename.'|cat'
            silent cd -
        endif
    endif
    unlet filename
endfun
