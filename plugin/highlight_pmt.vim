" highlight_pmt.vim:	hightlight print margin and trailing spaces
" Last Modified: Fri 15. Apr 2011 14:25:11 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_highlight_pmt") && g:loaded_highlight_pmt) || &cp
    finish
endif
let g:loaded_highlight_pmt = 1

" highlight print margin
function! HighlightPrintmargin()
	let m=''
	if exists('b:highlight_pm_id')
		silent! call matchdelete(b:highlight_pm_id)
		unlet b:highlight_ts_id
	endif
	if &textwidth > 0
		let m='\%' . &textwidth . 'v.'
		let b:highlight_pm_id = matchadd('Printmargin', m, 99)
	endif
endfunction

" highlight trailing spaces
function! HighlightTrailingSpace()
	if exists('b:highlight_ts_id')
		silent! call matchdelete(b:highlight_ts_id)
		unlet b:highlight_ts_id
	endif
	let b:highlight_ts_id = matchadd('TrailingSpace', '\s\+$', 99)
endfunction

hi Printmargin cterm=inverse gui=inverse
hi TrailingSpace cterm=inverse gui=inverse

augroup highlight_pmt
	autocmd!
	" hightlight trailing spaces and tabs and the defined print margin
	au BufEnter,WinEnter *	if !(exists('b:highlight_ts_id') && exists('b:highlight_pm_id')) && expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 | call HighlightPrintmargin() | call HighlightTrailingSpace() | endif
augroup END
