" highlight_pmt.vim:	hightlight first character beyond the print margin and trailing spaces
" Last Modified: Fri 07. Oct 2011 09:52:25 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.0
" License:		VIM LICENSE, see :h license

if (exists("g:loaded_highlight_pmt") && g:loaded_highlight_pmt) || &cp
    finish
endif
let g:loaded_highlight_pmt = 1

" highlight print margin
function! HighlightPrintmargin()
	hi def Printmargin cterm=inverse gui=inverse

	let found = 0
	let pattern='\%' . (&textwidth + 1) . 'v.'
	for m in getmatches()
		if m.group == 'Printmargin'
			if  &textwidth > 0 && !found && m.pattern == pattern
				let found = 1
			else
				call matchdelete(m.id)
			endif
		endif
	endfor

	" this is just too slow - use colorcolumn instead
	if &textwidth > 0 && !found
		call matchadd('Printmargin', pattern, 99)
	endif
endfunction

" highlight trailing spaces
function! HighlightTrailingSpace()
	hi def TrailingSpace cterm=inverse gui=inverse

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

augroup highlight_pmt
	autocmd!
	" hightlight trailing spaces and tabs and the defined print margin
	au BufEnter,WinEnter *	if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 | call HighlightTrailingSpace() | endif
augroup END
