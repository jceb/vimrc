" cd.vim:		Commands for dealing with directory changes
" Last Modified: Sun 26. May 2019 20:48:41 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_cd") && g:loaded_cd) || &cp
    finish
endif
let g:loaded_cd = 1

let s:defaults = {
      \ 'repo':          ['.git', '.hg', '.svn'],
      \ }

if ! exists('g:cd_repo')
    if exists('g:grepper.repo')
        let g:cd_repo = g:grepper.repo
    else
        let g:cd_repo = ['.git', '.hg', '.svn', 'debian']
    endif
endif

" Get root directory of the debian package you are currently in
function! GetRootDir()
    for repo in g:cd_repo
        let repopath = finddir(repo, expand('%:p:h').';')
        if empty(repopath)
            let repopath = findfile(repo, expand('%:p:h').';')
        endif
        if !empty(repopath)
            let repopath = fnamemodify(repopath, ':h')
            return fnameescape(repopath)
        endif
    endfor
    return ''
endfunction

" change to directory of the current buffer
command! CD :Cd
command! Cd :cd %:p:h
command! LCD :Lcd
command! Lcd :lcd %:p:h

" chdir to directory with subdirector ./debian (very useful if you do
" software development)
command! Cdroot :exec "cd ".GetRootDir()
command! Lcdroot :exec "lcd ".GetRootDir()

" add directories to the path variable which eases the use of gf and
" other commands operating on the path
command! Pathadd :exec "set path+=".expand("%:p:h")
command! Pathrm :exec "set path-=".expand("%:p:h")
command! PathaddRoot :exec "set path+=".GetRootDir()
command! PathrmRoot :exec "set path-=".GetRootDir()
