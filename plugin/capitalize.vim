" capitalize.vim:	Captialize words
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.7
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_capitalize") && g:loaded_capitalize) || &cp
    finish
endif
let g:loaded_capitalize = 1

" Captialize word (movent/selection)
function! Capitalize(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@
	let cursor_pos = getpos('.')

	if ! a:0 " non-visual mode selection
		if a:type == 'char'
			normal `[v`]o
			keeppatterns %s/\m\%V\(\%#\|\<\)\(.\)\(\k*\%V\k\?\)/\u\2\L\3/ge
		else
			keeppatterns '[,']s/\m\<\(.\)\(\k*\)/\u\1\L\2/ge
		endif
	else
		keeppatterns %s/\m\%V\<\(.\)\(\k*\%V\k\?\)/\u\1\L\2/ge
	endif

	call setpos('.', cursor_pos)
	let &selection = sel_save
	let @@ = reg_save
endfunction

nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
xnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>
