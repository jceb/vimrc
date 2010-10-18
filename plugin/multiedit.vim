" multiedit.vim:	Edit multiple files
" Last Modified: Mon 16. Aug 2010 18:33:12 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_split") && g:loaded_split) || &cp
    finish
endif
let g:loaded_split = 1

" vim tip: Opening multiple files from a single command-line
function! <SID>Sp(dir, ...)
	let split = 'sp'
	if a:dir == '1'
		let split = 'vsp'
	elseif a:dir == '2'
		let split = 'e'
	endif
	if(a:0 == 0)
		execute split
	else
		let i = a:0
		while(i > 0)
			execute 'let files = glob(a:' . i . ')'
			for f in split (files, "\n")
				execute split . ' ' . f
			endfor
			let i = i - 1
		endwhile
		windo if expand('%') == '' | q | endif
	endif
endfunction

" Improved versions of :sp and :vs which allow to open multiple files at once
command! -nargs=* -complete=file Sp call <SID>Sp(0, <f-args>)
command! -nargs=* -complete=file Vs call <SID>Sp(1, <f-args>)
command! -nargs=* -complete=file E call <SID>Sp(2, <f-args>)
