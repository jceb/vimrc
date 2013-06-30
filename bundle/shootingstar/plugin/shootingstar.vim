" shootingstar.vim:	Like the magic * but start matching at the cursor position
" Last Modified: Sun 30. Jun 2013 15:50:55 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Copyright:	2013, Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
" License:		VIM license, see :help license

if exists('loaded_shootingstar')
  finish
endif

let loaded_shootingstar = 1

function! <SID>Shootingstar()
    let col_cursor = col('.')
    let line = getline('.')
    let col_startword = match(line, '\k*\%'.col_cursor.'c\k*')
    if col_startword != -1
	let col_endword = match(line, '\k*\%'.col_cursor.'c\k*\zs') - 1
	let word = line[col_startword : col_endword]
	let offset = col_cursor - col_startword - 1
	if offset == 0
	    return '\zs'.word
	endif
	return word[ : offset - 1 ].'\zs'.word[ offset : ]
    endif
endfunction

nnoremap <Leader>* /\M\<<C-r>=<SID>Shootingstar()<CR>\><CR>
nnoremap <Leader># ?\M\<<C-r>=<SID>Shootingstar()<CR>\><CR>
nnoremap <Leader>g* /\M<C-r>=<SID>Shootingstar()<CR><CR>
nnoremap <Leader>g# ?\M<C-r>=<SID>Shootingstar()<CR><CR>
