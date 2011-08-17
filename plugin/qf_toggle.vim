" highlight_pmt.vim:	hightlight print margin and trailing spaces
" Last Modified: Sat 11. Dec 2010 23:07:40 +0100 CET
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_qf_toogle") && g:loaded_qf_toogle) || &cp
    finish
endif
let g:loaded_qf_toogle = 1

" toggles the quickfix window.
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
"command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle()
	if exists("g:qfix_win")
		cclose
		unlet! g:qfix_win
	else
		copen
	endif
endfunction

" used to track the quickfix window
augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
	autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

nnoremap <leader>q :call QFixToggle()<CR>
