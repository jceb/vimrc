" File: highlight.vim
" Author: Amit Sethi <amitrajsethi@yahoo.com>
" Version: 1.5
" Last Modified: Wed Sep  8 14:16:43 IST 2010
" Description: Highlight lines or patterns of interest in different colors
" Uasge:
"   Line mode
"     <C-h><C-h>   Highlight current line 
"     <C-h><C-a>   Advance color for next line highlight
"     <C-h><C-r>   Clear last line highlight
"
"   Pattern mode
"     <C-h><C-w>   Highlight word under cursor (whole word match)
"     <C-h><C-l>   Highlight all lines having word under cursor (whole word match)
"     <C-h><C-f>   Highlight word under cursor (partial word match)
"     <C-h><C-k>   Highlight all lines having word under cursor (partial word match)
"     <C-h><C-s>   Highlight last search pattern
"     <C-h><C-j>   Highlight all line having last search pattern
"     <C-h><C-d>   Clear last pattern highlight
"
"     <C-h><C-n>   Clear all highlights
"
"   All above commands work in both normal & insert modes.
"   <C-h><C-h> also works in visual mode. (Select desired lines & hit <C-h><C-h>)
"
" Installation:
"   Copy highlight.vim to your .vim/plugin directory
"
" Configuration:
"   To define custom colors set the following variables
"     g:lcolor_bg - Background color for line highlighting
"     g:lcolor_fg - Foreground color for line highlighting
"     g:pcolor_bg - Background color for pattern highlighting
"     g:pcolor_fg - Foreground color for pattern highlighting
"
" Limitation:
"   If you are using syntax highlighting based on keywords (e.g. language
"   specific keyword highlighting), then while highlighting lines, if the
"   line starts with a keyword, then sometimes that keyword is not highlighted,
"   while the rest of the line is hightlighted normally.
"

if exists("loaded_highlight") 
   finish
endif
let loaded_highlight = ""

syntax on

" -- Normal mode mappings --

" Highlight current line 
noremap  <silent> <C-h><C-h> :call <SID>Highlight("h") \| nohls<CR>
" Advance color for next line highlight
noremap  <silent> <C-h><C-a> :call <SID>Highlight("a")<CR>
" Clear last line highlight
noremap  <silent> <C-h><C-r> :call <SID>Highlight("r")<CR>

" Highlight word under cursor (whole word match)
noremap  <silent> <C-h><C-w> :call <SID>Highlight("w") \| nohls<CR>
" Highlight all lines having word under cursor (whole word match)
noremap  <silent> <C-h><C-l> :call <SID>Highlight("l") \| nohls<CR>
" Highlight word under cursor (partial word match)
noremap  <silent> <C-h><C-f> :call <SID>Highlight("f") \| nohls<CR>
" Highlight all lines having word under cursor (partial word match)
noremap  <silent> <C-h><C-k> :call <SID>Highlight("k") \| nohls<CR>
" Highlight last search pattern
noremap  <silent> <C-h><C-s> :call <SID>Highlight("s") \| nohls<CR>
" Highlight all lines having last search pattern
noremap  <silent> <C-h><C-j> :call <SID>Highlight("j") \| nohls<CR>
" Clear last pattern highlight
noremap  <silent> <C-h><C-d> :call <SID>Highlight("d")<CR>

" Clear all highlights
noremap  <silent> <C-h><C-n> :call <SID>Highlight("n")<CR>


" -- Insert mode mappings --

" Highlight current line 
inoremap <silent> <C-h><C-h> <C-o>:call <SID>Highlight("h")<CR>
" Advance color for next line highlight
inoremap <silent> <C-h><C-a> <C-o>:call <SID>Highlight("a")<CR>
" Clear last line highlight
inoremap <silent> <C-h><C-r> <C-o>:call <SID>Highlight("r")<CR>

" Highlight word under cursor (whole word match)
inoremap <silent> <C-h><C-w> <C-o>:call <SID>Highlight("w") \| nohls<CR>
" Highlight all lines having word under cursor (whole word match)
inoremap <silent> <C-h><C-l> <C-o>:call <SID>Highlight("l") \| nohls<CR>
" Highlight word under cursor (partial word match)
inoremap <silent> <C-h><C-f> <C-o>:call <SID>Highlight("f") \| nohls<CR>
" Highlight all lines having word under cursor (partial word match)
inoremap <silent> <C-h><C-k> <C-o>:call <SID>Highlight("k") \| nohls<CR>
" Highlight last search pattern
inoremap <silent> <C-h><C-s> <C-o>:call <SID>Highlight("s") \| nohls<CR>
" Highlight all lines having last search pattern
inoremap <silent> <C-h><C-j> <C-o>:call <SID>Highlight("j") \| nohls<CR>
" Clear last pattern highlight
inoremap <silent> <C-h><C-d> <C-o>:call <SID>Highlight("d")<CR>

" Clear all highlights
inoremap <silent> <C-h><C-n> <C-o>:call <SID>Highlight("n")<CR>


" Define colors for Line highlight
if !exists('g:lcolor_bg')
   let g:lcolor_bg = "purple,seagreen,violet,lightred,lightgreen,lightblue,darkmagenta,slateblue"
endif

if !exists('g:lcolor_fg')
   let g:lcolor_fg = "white,white,black,black,black,black,white,white"
endif

" Define colors for Pattern highlight
if !exists('g:pcolor_bg')
   let g:pcolor_bg = "yellow,blue,green,magenta,cyan,brown,orange,red"
endif

if !exists('g:pcolor_fg')
   let g:pcolor_fg = "black,white,black,white,black,white,black,white"
endif

" Highlight: Highlight line or pattern 
function! <SID>Highlight(mode)
   " Line mode
   if a:mode == 'h'
      let match_pat = '.*\%'.line(".").'l.*'
      "echo 'syn match '. s:lcolor_grp . s:lcolor_n . ' "' . match_pat . '" containedin=ALL'
      exec 'syn match '. s:lcolor_grp . s:lcolor_n . ' "' . match_pat . '" containedin=ALL'
   elseif a:mode == 'a'
      let s:lcolor_n = s:lcolor_n == s:lcolor_max - 1 ? 0 : s:lcolor_n + 1
   elseif a:mode == 'r'
      exec 'syn clear ' . s:lcolor_grp . s:lcolor_n
      let s:lcolor_n = s:lcolor_n == 0 ? 0 : s:lcolor_n - 1
   else
   endif

   let cur_word = a:mode == 's' || a:mode == 'j' ? @/ : expand("<cword>")

   " Pattern mode
   if cur_word == ""
      " do nothing
   elseif a:mode == 'f' || a:mode == 's'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' "' . cur_word . '" containedin=ALL'
   elseif a:mode == 'w'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' "\<' . cur_word . '\>" containedin=ALL'
   elseif a:mode == 'k' || a:mode == 'j'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' ".*' . cur_word . '.*" containedin=ALL'
   elseif a:mode == 'l'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' ".*\<' . cur_word . '\>.*" containedin=ALL'
   elseif a:mode == 'd'
      exec 'syn clear ' . s:pcolor_grp . s:pcolor_n
      let s:pcolor_n = s:pcolor_n == 0 ? 0 : s:pcolor_n - 1
   else
   endif

   " Clean all
   if a:mode == 'n'
      let ccol = 0
      while ccol < s:lcolor_max
         exec 'syn clear '. s:lcolor_grp . ccol
         let ccol = ccol + 1
      endw

      let ccol = 0
      while ccol < s:pcolor_max
         exec 'syn clear '. s:pcolor_grp . ccol
         let ccol = ccol + 1
      endw

      let s:lcolor_n = 0
      let s:pcolor_n = 0
   else
   endif

endfunction

" Strntok: Utility function to implement C-like strntok() by Michael Geddes
" and Benji Fisher at http://groups.yahoo.com/group/vimdev/message/26788
function! s:Strntok( s, tok, n)
    return matchstr( a:s.a:tok[0], '\v(\zs([^'.a:tok.']*)\ze['.a:tok.']){'.a:n.'}')
endfun

" ItemCount: Returns the number of items in the given string.
" Developed by Dan Sharp in MultipleSearch2.vim at
" http://www.vim.org/scripts/script.php?script_id=1183 
function! s:ItemCount(string)
    let itemCount = 0
    let newstring = a:string
    let pos = stridx(newstring, ',')
    while pos > -1
        let itemCount = itemCount + 1
        let newstring = strpart(newstring, pos + 1)
        let pos = stridx(newstring, ',')
    endwhile
    return itemCount
endfunction

" Min: Returns the minimum of the given parameters.
" Developed by Dan Sharp in MultipleSearch2.vim at
" http://www.vim.org/scripts/script.php?script_id=1183 
function! s:Min(...)
    let min = a:1
    let index = 2
    while index <= a:0
        execute "if min > a:" . index . " | let min = a:" . index . " | endif"
        let index = index + 1
    endwhile
    return min
endfunction

" HighlightInitL: Initialize the highlight groups for line highlight
" Based on 'MultipleSearchInit' function developed by Dan Sharp in 
" MultipleSearch2.vim at http://www.vim.org/scripts/script.php?script_id=1183 
function! s:HighlightInitL()
   let s:lcolor_grp = "LHiColor"
   let s:lcolor_n = 0

   let s:lcolor_max = s:Min(s:ItemCount(g:lcolor_bg . ','), s:ItemCount(g:lcolor_fg . ','))

   let ci = 0
   while ci < s:lcolor_max
      let bgColor = s:Strntok(g:lcolor_bg, ',', ci + 1)
      let fgColor = s:Strntok(g:lcolor_fg, ',', ci + 1)
     
      exec 'hi ' . s:lcolor_grp . ci .
         \ ' guifg =' . fgColor . ' guibg=' . bgColor
     
      let ci = ci + 1
   endw
endfunction

" HighlightInitP: Initialize the highlight groups for line highlight
" Based on 'MultipleSearchInit' function developed by Dan Sharp in 
" MultipleSearch2.vim at http://www.vim.org/scripts/script.php?script_id=1183 
function! s:HighlightInitP()
   let s:pcolor_grp = "PHiColor"
   let s:pcolor_n = 0

   let s:pcolor_max = s:Min(s:ItemCount(g:pcolor_bg . ','), s:ItemCount(g:pcolor_fg . ','))

   let ci = 0
   while ci < s:pcolor_max
      let bgColor = s:Strntok(g:pcolor_bg, ',', ci + 1)
      let fgColor = s:Strntok(g:pcolor_fg, ',', ci + 1)
     
      exec 'hi ' . s:pcolor_grp . ci .
         \ ' guifg =' . fgColor . ' guibg=' . bgColor
     
      let ci = ci + 1
   endw
endfunction


call s:HighlightInitL()
call s:HighlightInitP()


