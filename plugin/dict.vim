" dict.vim:		Integrate vim with dict
" Last Modified: Sun 05. Sep 2010 21:16:17 +0000 UTC
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_dict") && g:loaded_dict) || &cp
    finish
endif
let g:loaded_dict = 1

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <leader>L mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
nnoremap <leader>w mzyiw`z:exe "!dict -P - -- " . @"<CR>
" xnoremap <leader>L may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
xnoremap <leader>w mzy`z:exe "!dict -P - -- " . @"<CR>

nnoremap <leader>W :<C-u>silent !xdg-open 'https://dict.leo.org/ende/index_de.html\#/search=<cword>&searchLoc=0&resultOrder=basic&multiwordShowSingle=on'<CR>:redraw!<CR>
xnoremap <leader>W y:<C-u>exec "silent !xdg-open 'https://dict.leo.org/ende/index_de.html\\#/search=".@"."&searchLoc=0&resultOrder=basic&multiwordShowSingle=on'"<CR>:redraw!<CR>
