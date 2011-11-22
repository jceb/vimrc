" svn.vim -- a collection of useful functions for svn commit files
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-01-12
" @Last Modified: Sun 28. Sep 2008 11:41:31 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_svn")
    finish
endif
let b:loaded_svn = 1

nnoremap <leader>di :call b:Diff (0)<CR>
nnoremap <leader>diw :call b:Diff (1)<CR>

function! b:Diff (toBuffer)
    exec 'normal "zyiW'
    let filename=getreg('z')
    if filename != ''
        if a:toBuffer != 0
            vsplit
            exec 'normal l'
            ene
            set filetype=diff buftype=nofile
            silent cd $PWD
            exec '.!svn diff %:p:h'.'/'.filename
            silent cd -
        else
            silent cd $PWD
            exec '!svn diff %:p:h'.'/'.filename
            silent cd -
        endif
    endif
    unlet filename
endfun
