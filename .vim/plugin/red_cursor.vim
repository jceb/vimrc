" red_cursor.vim:	set cursor color to red
" Last Modified: Mon 10. May 2010 22:31:28 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_red_cursor") && g:loaded_red_cursor) || &cp
    finish
endif
let g:loaded_red_cursor = 1

" set cursor color
function! SetCursorColor()
	hi Cursor ctermfg=black ctermbg=red guifg=Black guibg=Red
	hi CursorLine term=underline cterm=underline gui=underline guifg=NONE guibg=NONE
endfunction

call SetCursorColor()

augroup red_cursor
	autocmd!
	au BufEnter,WinEnter *	:call SetCursorColor()
augroup END
