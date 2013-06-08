" dict.vim:		Integrate vim with dict
" Last Modified: Sun 05. Sep 2010 21:16:17 +0000 UTC
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_dict") && g:loaded_dict) || &cp
    finish
endif
let g:loaded_dict = 1

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <leader>L mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
nnoremap <leader>l mzyiw`z:exe "!dict -P - -- " . @"<CR>
" vnoremap <leader>L may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
vnoremap <leader>l mzy`z:exe "!dict -P - -- " . @"<CR>
