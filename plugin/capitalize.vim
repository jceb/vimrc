" capitalize.vim:	Captialize words
" Last Modified: Wed 04. Apr 2012 21:10:52 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2

if (exists("g:loaded_capitalize") && g:loaded_capitalize) || &cp
    finish
endif
let g:loaded_capitalize = 1

" Captialize word (movent/selection)
function! Capitalize(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	let p1 = []
	let p2 = []
	let vchar = ''

	if a:0  " Invoked from Visual mode, use '< and '> marks.
		let vchar = 'v'
		let p1 = getpos("'<")
		let p2 = getpos("'>")
	elseif a:type == 'line'
		let vchar = 'V'
		let p1 = getpos("'[")
		let p2 = getpos("']")
	elseif a:type == 'block'
		let vchar = '\<C-V>'
		let p1 = getpos("'[")
		let p2 = getpos("']")
	else
		let p1 = getpos("'[")
		let p2 = getpos("']")
	endif

	call setpos('.', p1)
	let cp = getpos('.')
	while cp[1] <= p2[1]
		if cp[1] == p2[1] && cp[2] > p2[2]
			break
		endif
		silent! exe "normal! vegumz`[~`zw"
		let tcp = getpos('.')
		if cp == tcp
			" break if the position doesn't change
			break
		endif
		let cp = tcp
	endwhile

	" restore visual selection
	if vchar != ''
		call setpos("'y", p1)
		call setpos("'z", p2)
		silent! exe "normal! `y".vchar."`z\<Esc>"
	endif
	silent! exe "normal! `]"

	let &selection = sel_save
	let @@ = reg_save
endfunction

nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
vnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>
