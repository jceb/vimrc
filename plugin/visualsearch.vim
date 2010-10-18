" visualsearch.vim:	Add support for using * and # in visual mode for search
" Last Modified: Sun 16. May 2010 17:06:20 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_visualsearch") && g:loaded_visualsearch) || &cp
    finish
endif
let g:loaded_visualsearch = 1

" search with the selection of the visual mode
fun! VisualSearch(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
	if a:direction == '#'
		"execute "normal! ?" . l:pattern . "^M"
		execute "normal! ?" . l:pattern
	elseif a:direction == '*'
		"execute "normal! /" . l:pattern . "^M"
		execute "normal! /" . l:pattern
	elseif a:direction == '/'
		execute "normal! /" . l:pattern
	else
		execute "normal! ?" . l:pattern
	endif
	let @/ = l:pattern
	let @" = l:saved_reg
endfun

" visual search
vnoremap <silent> * :call VisualSearch('*')<CR>
vnoremap <silent> # :call VisualSearch('#')<CR>
