" highlight_pmt.vim:	hightlight print margin and trailing spaces
" Last Modified: Fri 06. May 2011 11:46:56 +0900 JST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.0

if (exists("g:loaded_highlight_pmt") && g:loaded_highlight_pmt) || &cp
    finish
endif
let g:loaded_highlight_pmt = 1

" highlight print margin
function! HighlightPrintmargin()
	let found = 0
	let pattern='\%' . &textwidth . 'v.'
	for m in getmatches()
		if m.group == 'Printmargin'
			if  &textwidth > 0 && !found && m.pattern == pattern
				let found = 1
			else
				call matchdelete(m.id)
			endif
		endif
	endfor

	if &textwidth > 0 && !found
		call matchadd('Printmargin', pattern, 99)
	endif
endfunction

" highlight trailing spaces
function! HighlightTrailingSpace()
	let found = 0
	for m in getmatches()
		if m.group == 'TrailingSpace'
			if !found
				let found = 1
			else
				call matchdelete(m.id)
			endif
		endif
	endfor
	if !found
		call matchadd('TrailingSpace', '\s\+$', 99)
	endif
endfunction

hi Printmargin cterm=inverse gui=inverse
hi TrailingSpace cterm=inverse gui=inverse

augroup highlight_pmt
	autocmd!
	" hightlight trailing spaces and tabs and the defined print margin
	au BufEnter,WinEnter *	if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 | call HighlightPrintmargin() | call HighlightTrailingSpace() | endif
augroup END
