"=============================================================================
" FILE: snippets.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 26 Oct 2009
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
if !exists('b:undo_indent')
    let b:undo_indent = ''
endif

setlocal indentexpr=SnippetsIndent()

function! SnippetsIndent()"{{{
    let l:line = getline('.')
    let l:prev_line = (line('.') == 1)? '' : getline(line('.')-1)

    if l:prev_line =~ '^\s*$'
        return 0
    elseif l:prev_line =~ '^\%(include\|snippet\|abbr\|prev_word\|rank\|delete\|alias\|condition\)'
                \&& l:line !~ '^\s*\%(include\|snippet\|abbr\|prev_word\|rank\|delete\|alias\|condition\)'
        return &shiftwidth
    else
        return match(l:line, '\S')
    endif
endfunction"}}}

let b:undo_indent .= '
    \ | setlocal expandtab< shiftwidth< softtabstop<
    \'
