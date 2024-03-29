" git.vim -- a collection of useful functions for git commit files
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-02-26
" @Last Modified: Thu 02. Oct 2008 00:02:55 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
"
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_git")
    finish
endif
let b:loaded_git = 1

finish " disable for the moment

nnoremap <leader>gdi :call <SID>diff(0)<CR>
nnoremap <leader>gdw :call <SID>diff(1)<CR>

function! s:diff(toBuffer)
    exec 'normal "zyiW'
    let filename=getreg('z')
    if filename != ''
        if a:toBuffer != 0
            vsplit
            exec 'normal l'
            ene
            set filetype=diff buftype=nofile
            exec ".!unset GIT_INDEX_FILE; unset GIT_DIR; git diff-index -p HEAD -- '".$GIT_PREFIX.filename."'|cat"
        else
            exec "!unset GIT_INDEX_FILE; unset GIT_DIR; git diff-index -p HEAD -- '".$GIT_PREFIX.filename."'|cat"
        endif
    endif
    unlet filename
endfun
