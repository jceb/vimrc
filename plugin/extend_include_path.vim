" extend_include_path.vim:	Extend path variable by the contents of
" .include_path file in the same directory of the currently edited file
" Last Modified: Sun 16. May 2010 17:04:18 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_extend_include_path") && g:loaded_extend_include_path) || &cp
    finish
endif
let g:loaded_extend_include_path = 1

" reads the file .include_path - useful for C programming
function! <SID>ExtendIncludePath()
	let include_path = expand("%:p:h") . '/.include_path'
	if filereadable(include_path)
		for line in readfile(include_path, '')
			exec "setl path +=," . line
		endfor
	endif
endfunction

augroup extend_include_path
	autocmd!
	au BufReadPost,BufNewFile *		call <SID>ExtendIncludePath()
augroup END
