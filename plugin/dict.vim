" dict.vim:		Integrate vim with dict
" Last Modified: Sun 05. Sep 2010 21:16:17 +0000 UTC
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_dict") && g:loaded_dict) || &cp
    finish
endif
let g:loaded_dict = 1

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <Leader>T mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
nnoremap <Leader>t mzyiw`z:exe "!dict -P - -- " . @"<CR>
" vnoremap <Leader>T may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
vnoremap <Leader>t mzy`z:exe "!dict -P - -- " . @"<CR>
