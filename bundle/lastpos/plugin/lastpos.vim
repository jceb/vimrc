" Vim plugin -- last-position-jump improved (esp. for Easy Vim)
" File:         lastpos.vim
" Created:      2010 Apr 08     (new approach!)
" Last Change:  2010 Apr 09
" Rev Days:     1
" Author:       Andy Wokula <anwoku@yahoo.de>
" Version:      0.6

if exists("loaded_lastpos")
    finish
endif
let loaded_lastpos = 1

if v:version < 700 || &cp
    echomsg "lastpos: you need at least Vim 7.0 and 'nocp' set"
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup LastPos
    au!
    au BufWinEnter * call s:LastPos()
augroup End

func! s:LastPos()
    let lastpos_want = getpos("'\"")
    if lastpos_want != [0,1,1,0] && lastpos_want[1] <= line("$")
        \ && getpos(".") == [0,1,1,0] && &buftype == ""
        normal! g`"
        if lastpos_want != getpos(".")
            exec printf("au! LastPos InsertEnter * call s:AdjustPos(%s, %d)",
                \ string(getpos(".")), bufnr(""))
            au! LastPos CursorMoved * au! LastPos InsertEnter,CursorMoved
        endif
    endif
endfunc

func! s:AdjustPos(badpos, bufnr)
    if getpos(".") == a:badpos && bufnr("") == a:bufnr
        call feedkeys("\<Right>")
    endif
    au! LastPos InsertEnter
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:et tw=72 sts=4 sw=4:
