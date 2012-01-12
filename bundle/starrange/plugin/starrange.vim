" StarRange
"
" Description:
"   Search a string that you selected in visual mode.
" Last Change: 2009-2-12
" Maintainer: Shuhei Kubota <kubota.shuhei+vim@gmail.com>
" Installation:
"   Just source this file. (Put this file into the plugin directory.)
" Usage:
"   [Settings]
"
"   Change mapping.
"
"   [Usual]
"
"   Select a string in visual mode. Press * or # key.
"

xnoremap * :call <SID>StarRange__keepReg()<CR>gv"*y/\V<C-R>=<SID>StarRange__substituteSpecialChars(@*)<CR><CR>:call <SID>StarRange__restoreReg()<CR>:echo<CR>
xnoremap # :call <SID>StarRange__keepReg()<CR>gv"*y?\V<C-R>=<SID>StarRange__substituteSpecialChars(@*)<CR><CR>:call <SID>StarRange__restoreReg()<CR>:echo<CR>

let s:StarRange__reg = ''

function! s:StarRange__keepReg()
  let s:StarRange__reg = @*
endfunction

function! s:StarRange__restoreReg()
  let @* = s:StarRange__reg
endfunction

function! s:StarRange__substituteSpecialChars(str)
    let result = escape(a:str, '\')
    let result = substitute(result, '/', '\\/', 'g')
    let result = substitute(result, '\r\n\|\r\|\n', '\\n', 'g')
    return result
endfunction

" vim: set et ff=unix fileencoding=utf-8 ft=vim sts=4 sw=4 ts=4 tw=78 : 
