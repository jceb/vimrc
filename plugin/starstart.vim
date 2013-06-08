" starstart.vim:	Extension for the star mapping.  Search word under cursor, but start matching at the cursor position
" Last Modified: Sat 08. Jun 2013 09:17:35 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
" License:		VIM LICENSE, see :h license

function! Starstart()
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

" make the cursor stay at the current position
nnoremap \* msHmt`s/\M\<<C-r>=Starstart()<CR>\><CR>'tzt`s
nnoremap \# msHmt`s?\M\<<C-r>=Starstart()<CR>\><CR>'tzt`s

" uncomment these lines if you want to have normal search behavior
" nnoremap \* /\M\<<C-r>=Starstart()<CR>\><CR>
" nnoremap \# ?\M\<<C-r>=Starstart()<CR>\><CR>
