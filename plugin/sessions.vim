" sessions.vim:	Mappings for dealing with vim or quickfix sessions
" Last Modified: Sun 23. May 2010 21:01:02 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" Recommendation: Remove options and folds from sessionoptions to make restore
" work with changed .vimrc and throw less error messages:
" set sessionoptions-=options,folds

if (exists("g:loaded_sessions") && g:loaded_sessions) || &cp
    finish
endif
let g:loaded_sessions = 1

function! <SID>Create_directory(dir)
	if isdirectory(a:dir) != 0
		mkdir(a:dir)
	endif
endfunction

" store, load and delete vimessions
nmap <leader>ss <leader>sc
nnoremap <leader>sc :call <SID>Create_directory('~/.vimsessions')<CR>:mksession! ~/.vimsessions/
nnoremap <leader>sl :call <SID>Create_directory('~/.vimsessions')<CR>:source ~/.vimsessions/
nnoremap <leader>sd :call <SID>Create_directory('~/.vimsessions')<CR>:!rm ~/.vimsessions/

" store, load and delete quickfix information
nmap <leader>qq <leader>qc
nnoremap <leader>qc :call <SID>Create_directory('~/.vimquickfix')<CR>:QFNSave ~/.vimquickfix/
nnoremap <leader>ql :call <SID>Create_directory('~/.vimquickfix')<CR>set efm=%f:%l:%c:%m<CR>:cgetfile ~/.vimquickfix/
nnoremap <leader>qd :call <SID>Create_directory('~/.vimquickfix')<CR>:!rm ~/.vimquickfix/
