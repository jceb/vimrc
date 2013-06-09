" shootingstar.vim:	Like the magic * but start matching at the cursor position
" Last Modified: Sun 09. Jun 2013 20:46:39 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Copyright:	2013, Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
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

nnoremap \* /\M\<<C-r>=<SID>Shootingstar()<CR>\><CR>
nnoremap \# ?\M\<<C-r>=<SID>Shootingstar()<CR>\><CR>
