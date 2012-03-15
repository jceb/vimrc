" red_cursor.vim:	set cursor color to red
" Last Modified: Mon 18. Apr 2011 18:26:55 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_red_cursor") && g:loaded_red_cursor) || &cp
    finish
endif
let g:loaded_red_cursor = 1

" set cursor color
function! SetCursorColor()
	hi Cursor term=NONE cterm=NONE ctermfg=black ctermbg=red gui=NONE guifg=Black guibg=Red
	"hi CursorLine term=underline cterm=underline gui=underline guifg=NONE guibg=NONE
endfunction

call SetCursorColor()

augroup red_cursor
	autocmd!
	au BufEnter,WinEnter *	:call SetCursorColor()
augroup END
