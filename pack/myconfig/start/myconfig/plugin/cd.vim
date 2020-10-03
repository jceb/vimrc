" cd.vim:		Commands for dealing with directory changes
" Last Modified: Sun 26. May 2019 20:48:41 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_cd") && g:loaded_cd) || &cp
    finish
endif
let g:loaded_cd = 1

if ! exists('g:root_elements')
    let g:root_elements = ['.git', '.hg', '.svn', 'debian', 'package.json']
endif

" Get root directory of the currently edited file
function! GetRootDir()
    let l:rootdir = ''
    let l:repopath = expand('%:p:h')
    while l:rootdir == '' && l:repopath != '/'
        for elem in g:root_elements
            let l:path = finddir(elem, l:repopath.';'.l:repopath)
            if empty(l:path)
                let l:path = findfile(elem, l:repopath.';'.l:repopath)
            endif
            if !empty(l:path)
                let l:rootdir = fnamemodify(l:path, ':h')
                break
            endif
        endfor
        let l:repopath = fnamemodify(l:repopath, ':h')
    endwhile
    return l:rootdir
endfunction

" change to directory of the current buffer
command! CD :Cd
command! Cd :cd %:p:h<bar>pwd
command! LCD :Lcd
command! Lcd :lcd %:p:h<bar>pwd
command! TCD :Tcd
command! Tcd :tcd %:p:h<bar>pwd

command! -complete=dir -nargs=1 Wcd :let s:winnr = winnr()<bar>exec "silent cd ".fnameescape(<f-args>)<Bar>exec "windo silent cd ".fnameescape(getcwd())<bar>pwd<Bar>exec s:winnr."wincmd w"
command! -complete=dir -nargs=1 Wlcd :let s:winnr = winnr()<bar>exec "silent lcd ".fnameescape(<f-args>)<Bar>exec "windo silent lcd ".fnameescape(getcwd())<bar>pwd<Bar>exec s:winnr."wincmd w"
command! -complete=dir -nargs=1 Wtcd :let s:winnr = winnr()<bar>exec "silent tcd ".fnameescape(<f-args>)<Bar>exec "windo silent tcd ".fnameescape(getcwd())<bar>pwd<Bar>exec s:winnr."wincmd w"

" change to directory of the current buffer
command! WindoCD :WindowCd
command! WindoCd :let s:winnr = winnr()<Bar>exec "windo silent cd ".fnameescape(expand("%:p:h"))<bar>pwd<Bar>exec s:winnr."wincmd w"
command! WindoLCD :WindowLcd
command! WindoLcd :let s:winnr = winnr()<Bar>exec "windo silent lcd ".fnameescape(expand("%:p:h"))<bar>pwd<Bar>exec s:winnr."wincmd w"
command! WindoTCD :WindowTCD
command! WindoTcd :let s:winnr = winnr()<Bar>exec "windo silent tcd ".fnameescape(expand("%:p:h"))<bar>pwd<Bar>exec s:winnr."wincmd w"

" chdir to directory with subdirector ./debian (very useful if you do
" software development)
command! Cdroot :exec "cd ".fnameescape(GetRootDir())
command! Lcdroot :exec "lcd ".fnameescape(GetRootDir())
command! Tcdroot :exec "tcd ".fnameescape(GetRootDir())

" chdir to directory with subdirector ./debian (very useful if you do
" software development)
command! WindoCdroot :let s:winnr = winnr()<Bar>exec "windo silent cd ".fnameescape(GetRootDir())<Bar>pwd<Bar>exec s:winnr."wincmd w"
command! WindoLcdroot ::let s:winnr = winnr()<Bar>exec "windo silent lcd ".fnameescape(GetRootDir())<Bar>pwd<Bar>exec s:winnr."wincmd w"
command! WindoTcdroot ::let s:winnr = winnr()<Bar>exec "windo silent tcd ".fnameescape(GetRootDir())<Bar>pwd<Bar>exec s:winnr."wincmd w"

" add directories to the path variable which eases the use of gf and
" other commands operating on the path
command! Pathadd :exec "set path+=".expand("%:p:h")
command! Pathrm :exec "set path-=".expand("%:p:h")
command! PathaddRoot :exec "set path+=".GetRootDir()
command! PathrmRoot :exec "set path-=".GetRootDir()
