" find.vim:		Find files starting in the current directory and open found
" file for editing
" Last Modified: Mon 16. Aug 2010 18:42:22 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_find") && g:loaded_find) || &cp
    finish
endif
let g:loaded_find = 1

" Find files in current directory and load them into quickfix list
" Source: http://vim.wikia.com/wiki/Find_files_in_subdirectories
" @param	a:1	bang - if present, don't jump to the first file found
" @param	a:2	searchtype 'i'gnorecase or 'n'ormal
" @param	a:3	searchterm
" @param	a:4	path (optional)
function! <SID>Find(...)
	let l:bang = a:1
	let l:searchtype = '-name'
	if a:2 == 'i'
		let l:searchtype = '-iname'
	endif
	let searchterm = a:3
	let path = getcwd()
	if a:0 == 4
		let path = a:4
	endif
	let l:list = split(system("find '".path."' -not -wholename '*/.bzr/*' -a -not -wholename '*/.hg/*' -a -not -wholename '*/.git/*' -a -not -wholename '*.svn/*' -a -not -wholename '*/CVS/*' -type f ".l:searchtype." '*".searchterm."*'"), '\n')
	if len(l:list) < 1
		echo "'".searchterm."' not found"
		return
	else
		call setqflist([])
		for f in l:list
			call setqflist([{'filename': f, 'lnum': 1}], 'a')
		endfor
		if l:bang != '!'
			cc
		endif
	endif
endfunction

" Find files
command! -bang -nargs=* -complete=file Find :call <SID>Find("<bang>", 'i', <f-args>)
