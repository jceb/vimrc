" highlight_pmt.vim:	hightlight print margin and trailing spaces
" Last Modified: Sun 16. May 2010 17:31:49 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_highlight_pmt") && g:loaded_highlight_pmt) || &cp
    finish
endif
let g:loaded_highlight_pmt = 1

" highlight print margin
function! HighlightPrintmargin()
	hi Printmargin cterm=inverse gui=inverse
	let m=''
	if &textwidth > 0
		let m='\%' . &textwidth . 'v.'
		exec 'match Printmargin /' . m .'/'
	else
		match
	endif
endfunction

" highlight trailing spaces
function! HighlightTrailingSpace()
	hi TrailingSpace cterm=inverse gui=inverse
	syntax match TrailingSpace '\s\+$' display containedin=ALL
endfunction

augroup highlight_pmt
	autocmd!
	" hightlight trailing spaces and tabs and the defined print margin
	au BufEnter,WinEnter *	match | if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 | call HighlightPrintmargin() | call HighlightTrailingSpace() | endif
augroup END
