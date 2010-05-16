" save.vim:		Save current file under different filename and delete old (alternate) file
" Last Modified: Sun 16. May 2010 17:23:18 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_save") && g:loaded_save) || &cp
    finish
endif
let g:loaded_save = 1

" 'Save' saves current file under specified name and delete alternate (current) file
function! <SID>Save(file)
	if bufname('%') != '' && bufname('%') != a:file
		exec ':sav '.a:file
		call delete(bufname('#'))
		bw #
	endif
endfunction

" 'Save' saves current file under specified name and delete alternate (current) file
command! -nargs=1 -complete=file Save call <SID>Save(<f-args>)
command! -nargs=1 -complete=file Sav call <SID>Save(<f-args>)
