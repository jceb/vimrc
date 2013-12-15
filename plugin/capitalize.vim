" capitalize.vim:	Captialize words
" Last Modified: Wed 04. Apr 2012 21:10:52 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.3
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
	if a:0 " Invoked from Visual mode, use '< and '> marks.
		let vchar = 'v'
		let start_pos = getpos("'<")
		let end_pos = getpos("'>")
	elseif a:type == 'line'
		let vchar = 'V'
		let start_pos = getpos("'[")
		let start_pos[2] = 1
		let end_pos = getpos("']")
		let end_pos[2] = len(getline(end_pos[1]))
	elseif a:type == 'block'
		throw "Visual block mode not supported yet!"
		let vchar = '\<C-V>'
		let start_pos = getpos("'[")
		let end_pos = getpos("']")
	else
		let vchar = ''
		let start_pos = getpos("'[")
		let end_pos = getpos("']")
	endif

	call setpos('.', start_pos)
	let current_pos = copy(start_pos)
	while current_pos[1] <= end_pos[1]
		if current_pos[1] == end_pos[1] && current_pos[2] > end_pos[2]
			break
		endif
		silent! exe "normal! vegu`[~`[w"
		let tmp_pos = getpos('.')
		if current_pos == tmp_pos
			" break if the position doesn't change
			break
		endif
		let current_pos = tmp_pos
	endwhile

	" restore visual selection
	if vchar != ''
		call setpos("'[", start_pos)
		call setpos("']", end_pos)
		exe "normal! `[".vchar."`]\<Esc>"
	endif

	" restore position cursor like gU and gu
	let start_pos[2] = cursor_pos[2]
	call setpos('.', start_pos)

	let &selection = sel_save
	let @@ = reg_save
endfunction

nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
vnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>
