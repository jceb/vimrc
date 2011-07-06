" transwrd.vim: Swap two words as M-t (transpose-words) function in Emacs (Bash)
"               This version of the script act more likely to M-t in Bash
"               rather than in emacs.
" Last Change:  2011-07-06
" Maintainer:   Fermat <Fermat618@gmail.com>
" Licence: This script is released under the Vim License.
" Install: 
"     Put this file in ~/.vim/plugin
" Mappings:
"     <Alt-t> (<Meta-t>) in any mode except command-line with '=' prompt.
"         transpose words. Same as press <Alt-t> (<Meta-t>) in Emacs or
"         Bash(default mode)
" Global Variable:
"     g:transwrd_wordpattern
"     When set, s:wordpattern (default '\k\+') will be set to it. This only
"     take effect the first time the script is loaded.

if exists("g:loaded_transwrd")
    finish
endif
let g:loaded_transwrd = 1
let s:save_cpo = &cpo
set cpo&vim

if exists("g:transwrd_wordpattern")
    let s:wordpattern = g:transwrd_wordpattern
else 
    let s:wordpattern = '\k\+'
endif

" Functions
let s:largest_offset = 1024 - 1
function s:transpose_word_inline(cline, col)
    if a:col > s:largest_offset
        let m_start = a:col - s:largest_offset
    else
        let m_start = 0
    endif
    let prev = {}
    let this = {}
    let m_start_new = match(a:cline, s:wordpattern, m_start)
    if m_start_new == -1
        return [a:cline, a:col]
    else
        let prev.start = m_start_new
        let prev.end = matchend(a:cline, s:wordpattern, m_start)
        if prev.end - prev.start == 0
            return [a:cline, a:col]
        endif
        let prev.str = matchstr(a:cline, s:wordpattern, m_start)
        let m_start = prev.end
    endif
    let m_start_new = match(a:cline, s:wordpattern, m_start)
    if m_start_new == -1
        return [a:cline, a:col]
    else
        let this.start = m_start_new
        let this.end = matchend(a:cline, s:wordpattern, m_start)
        if this.end - this.start == 0
            return [a:cline, a:col]
        endif
        let this.str = matchstr(a:cline, s:wordpattern, m_start)
        let m_start = this.end
    endif

    if prev.end > a:col - 1
        return [a:cline, a:col]
    elseif this.end > a:col - 1
    else
        let m_start_new = match(a:cline, s:wordpattern, m_start)
        while m_start_new != -1
            let m_end = matchend(a:cline, s:wordpattern, m_start)
            if m_end - m_start_new == 0
                return [a:cline, a:col]
            endif
            let prev = deepcopy(this)
            let this.start = m_start_new
            let this.end = m_end
            let this.str = matchstr(a:cline, s:wordpattern, m_start)
            let m_start = this.end
            let m_start_new = match(a:cline, s:wordpattern, m_start)
            if this.end > a:col - 1
                break
            endif
        endwhile
    endif
    let cline = strpart(a:cline, 0, prev.start) . this.str .
                \ strpart(a:cline, prev.end, this.start - prev.end) .
                \ prev.str . strpart(a:cline, this.end)
    return [cline, this.end + 1]
endfunction

function s:transpose_word()
    let cline = getline(".")
    let col = col(".")
    let cline_col = s:transpose_word_inline(cline, col)
    if cline_col ==# [cline, col]
        return ''
    else
        let lnum = line(".")
        call setline(lnum, cline_col[0])
        call setpos(".", [0, lnum, cline_col[1], 0])
    endif
    return ''
endfunction

function s:transpose_word_cmdline()
    let cline = getcmdline()
    let col = getcmdpos()
    let cline_col = s:transpose_word_inline(cline, col)
    if cline_col !=# [cline, col]
        call setcmdpos(cline_col[1])
    endif
    return cline_col[0]
endfunction

" Mappings
nnoremap <unique> <silent> <Plug>Transposewords :call <SID>transpose_word()<CR>
inoremap <unique> <silent> <Plug>Transposewords <C-R>=<SID>transpose_word()<CR>
cnoremap <unique> <Plug>Transposewords <C-\>e<SID>transpose_word_cmdline()<CR>

if !hasmapto('<Plug>Transposewords')
    nmap <unique> <M-t> <Plug>Transposewords
    imap <unique> <M-t> <Plug>Transposewords
    cmap <unique> <M-t> <Plug>Transposewords
endif

let &cpo = s:save_cpo

" vim:set ft=vim expandtab sw=4 tw=79:
