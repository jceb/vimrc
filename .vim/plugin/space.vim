" space.vim:	Mappings which help dealing with spaces, tabs and word
" delimiters in search terms
" Last Modified: Mon 24. May 2010 16:16:28 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_space") && g:loaded_space) || &cp
    finish
endif
let g:loaded_space = 1

" kill/delete trailing spaces and tabs
nnoremap <Leader>kt msHmt:silent! g!/^-- $/s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing spaces"<CR>'tzt`s
vnoremap <Leader>kt :s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing, spaces"<CR>

" kill/reduce inner spaces and tabs to a single space/tab
nnoremap <Leader>ki msHmt:silent! %s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>'tzt`s
vnoremap <Leader>ki :s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>

" remove word delimiter from search term
function! Remove_word_delimiter_from_search()
	let tmp = substitute(substitute(@/, '^\\<', '', ''), '\\>$', '', '')
	execute "normal! /" . tmp
	let @/ = tmp
	unlet tmp
endfunction
nnoremap <silent> <leader>> :call Remove_word_delimiter_from_search()<CR>
nmap <silent> <leader>< <leader>>
