" find.vim:		Find files starting in the current directory and open found
" file for editing
" Last Modified: Sun 20. Jun 2010 20:38:49 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_find") && g:loaded_find) || &cp
    finish
endif
let g:loaded_find = 1

" Find files in current directory and load them into quickfix list
" Source: http://vim.wikia.com/wiki/Find_files_in_subdirectories
" @param	a:0	searchtype 'i'gnorecase or 'n'ormal
" @param	a:1	searchterm
" @param	a:2	path (optional)
function! <SID>Find(...)
	let searchtype = '-name'
	if a:1 == 'i'
		let searchtype = '-iname'
	endif
	let searchterm = a:2
	let path = getcwd()
	if a:0 == 3
		let path = a:3
	endif
	let l:list = system("find ".path." -not -wholename '*/.bzr*' -a -not -wholename '*/.hg*' -a -not -wholename '*/.git*' -a -not -wholename '*.svn*' -a -not -wholename '*/CVS*' -type f ".searchtype." '*".searchterm."*'")
	let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
	if l:num < 1
		echo "'".searchterm."' not found"
		return
	endif
	if l:num != 1
		let tmpfile = tempname()
		exe "redir! > " . tmpfile
		silent echon l:list
		redir END
		let old_efm = &efm
		set efm=%f

		if exists(":cgetfile")
			execute "silent! cgetfile " . tmpfile
		else
			execute "silent! cfile " . tmpfile
		endif

		let &efm = old_efm

		" Open the quickfix window below the current window
		botright copen

		call delete(tmpfile)
	endif
endfunction

" Find files
command! -nargs=* -complete=file Find :call <SID>Find('i', <f-args>)
command! -nargs=* -complete=file FFind :call <SID>Find('n', <f-args>)
