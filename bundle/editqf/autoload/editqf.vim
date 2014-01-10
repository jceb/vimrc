" editqf.vim -- make quickfix entries editable
" Author:         Jan Christoph Ebersbach (jceb@e-jc.de)
" License:        GPL (see http://www.gnu.org/licenses/gpl.txt)
" Created:        2008-11-28
" Last Modified: Fri 10. Jan 2014 22:22:18 +0100 CET
" Revision:       1.4
" vi:             ft=vim:tw=80:sw=4:ts=8

if exists("g:loaded_editqf_auto") || &cp
    finish
endif
let g:loaded_editqf_auto = 1

function! editqf#Getlist(winnr, type)
	if a:type == 'qf'
		return getqflist()
	else
		return getloclist(a:winnr)
	endif
endfunction

function! editqf#Setlist(winnr, type, list, action)
	if a:type == 'qf'
		call setqflist(a:list, a:action)
	else
		call setloclist(a:winnr, a:list, a:action)
	endif
endfunction

function! editqf#RemoveEmptyPattern(winnr, type)
	let l = []
	let found_empty_pattern = 0
	for i in editqf#Getlist(a:winnr, a:type)
		if i.pattern == '^\V3MPT1\$'
			unlet i.pattern
			let found_empty_pattern = 1
		endif
		call add(l, i)
	endfor
	if found_empty_pattern == 1
		call editqf#Setlist(a:winnr, a:type, l, 'r')
	endif
endfunction

function! editqf#AddNote(bang, type, matchtype, ...)
	" @param	type		qf or loc
	" @param	matchtype	l(ine number) or p(attern)

	let note = ""
	if a:0 > 0
		let first = 1
		for i in a:000
			if first == 1
				let first = 0
				let note = i
			else
				let note = note." ".i
			endif
		endfor
	else
		call inputsave()
		let note = input("Enter Note: ")
		call inputrestore()
	endif
	if note == ""
		return
	endif

	let entry = {}
	let entry["bufnr"]    = bufnr("%")
	if exists('g:editqf_store_absolute_filename') && g:editqf_store_absolute_filename == 1
		let entry["filename"] = expand("%:p")
	else
		let entry["filename"] = expand("%")
	endif
	let entry["lnum"]     = ""
	let entry["col"]      = ""
	let entry["pattern"]  = ""
	if a:matchtype == 'l'
		let entry["lnum"]     = line(".")
		let entry["col"]      = col(".")
	else
		" / needs to be escaped in order jump to prevent the pattern from
		" ending too early
		let entry["pattern"]  = '^\V'.substitute(getline('.'), '/', '\\/', 'g').'\$'
	endif
	let entry["vcol"]     = ""
	"let entry["nr"]       = 0
	let entry["text"]     = note
	let entry["type"]     = "I"

	if a:bang == '!'
		call editqf#Setlist(0, a:type, [entry], "r")
	else
		call editqf#Setlist(0, a:type, [entry], "a")
	endif
	redraw!
	echom "Note added."

	if exists(':HierUpdate')
		HierUpdate
	endif
endfunction

function! editqf#Save(bang, type, ...)
	let file = a:type == "qf" ? g:editqf_saveqf_filename : g:editqf_saveloc_filename
	if a:0 > 0
		let file = a:1
	endif
	let file = expand(file)

	if (filewritable(fnameescape(file)) == 1 && a:bang == '!') || filereadable(fnameescape(file)) == 0
		let items = []
		let winnr = a:type == 'qf' ? '' : 0
		for i in editqf#Getlist(winnr, a:type)
			let pattern = i.pattern
			if pattern != '' && len(pattern) >= 5
				let pattern = pattern[3:-3]
			else
				let pattern = '3MPT1'
			endif
			let type = i.type
			if i.type == ''
				let type = 'E'
			endif
			call add(items, bufname(i.bufnr) . ':' . type . ':' . i.lnum . ':' . i.col . ':' . pattern . ':' . i.text)
		endfor
		call writefile(items, fnameescape(file))
	else
		echomsg "File exists (add ! to override) " . file
	endif
endfunction

function! editqf#Load(bang, type, ...)
	let file = g:editqf_saveqf_filename
	let get = a:type == "qf" ? "caddfile" : "laddfile"
	if a:bang == '!'
		let get = a:type == "qf" ? "cgetfile" : "lgetfile"
	endif

	if a:0 > 0
		let file = a:1
	endif
	let file = expand(file)

	if filereadable(fnameescape(file)) == 1
			let tmp_efm = &efm
			" set efm to the format used to store errors in a file
			set efm=%f:%t:%l:%c:%s:%m
			exec get." ".fnameescape(file)
			let &efm=tmp_efm

			call editqf#RemoveEmptyPattern(0, a:type)
	else
		echomsg "Unable to open file " . file
	endif

	if exists(':HierUpdate')
		HierUpdate
	endif
endfunction

function! editqf#Cleanup(loadqf)
	if ! exists("s:current_bufnr") || ! bufexists(s:current_bufnr)
		return
	endif
	let get = s:current_type == 'qf' ? 'cgetbuffer' : 'lgetbuffer'

	" delete every empty line - empty lines cause empty entries in quickfix
	" list
	silent! g/^\(\s*$\|bufnr:\)/d

	let empty_list = 0
	if getline(1) == ""
		let empty_list = 1
		call editqf#Setlist(s:current_winnr, s:current_type, [], 'r')
	endif

	if a:loadqf == 0
		" close quickfix window
		silent! au! qfbuffer
		exec "bw! ".s:current_bufnr
		if empty_list == 0 && g:editqf_jump_to_error == 1
			if s:current_type == "qf"
				exec "cc ".s:current_error
			else
				exec "ll ".s:current_error
			endif
		else
			cclose
		endif
		unlet! s:current_winnr s:current_bufnr s:current_error s:current_type
	else
		" read new quickfix data
		if empty_list == 0
			let tmp_efm = &efm
			" set efm to the format used to store errors in a file
			set efm=%f:%t:%l:%c:%s:%m
			exec get." ".s:current_bufnr

			call editqf#RemoveEmptyPattern(s:current_winnr, s:current_type)
			let &efm=tmp_efm
		endif
		" prepend column information again
		call append(0, ['bufnr:type:lnum:col:pattern:text'])
		set nomodified
	endif

	if exists(':HierUpdate')
		HierUpdate
	endif
endfunction

function! editqf#Edit()
	let line = line(".")
	let col = col(".") - 1

	" remember the current error jump to it once editing finished
	let s:current_error = line
	" increase line by one, because the Read function adds a description at
	" the top
	let line += 1

	" remember the current window number. It's used to update the location
	" list later on
	let s:current_winnr = winnr()

	" WARNING: unfortunately it's not possible to determine the difference
	" between quickfix and location list from within vim script. When editing
	" a location list the quickfix list is edited instead
	let type = 'qf'

	" split a new window and open quickfix/location list for editing
	exec "silent! ".winheight(0)."sp"
	if type == "qf"
		e qf:list
	else
		e loc:list
	endif

	" move cursor to the column it was in when editing started in the quickfix window
	exec "normal ".line."G0" . col . "l"
endfunction

function! editqf#Read(fname)
	let items = ['bufnr:type:lnum:col:pattern:text']
	let type = 'qf'
	if fnamemodify(a:fname, ':t') == 'loc:list'
		let type = 'loc'
	endif

	let s:current_error = ! exists('s:current_error') ? 1 : s:current_error
	let s:current_winnr = ! exists('s:current_winnr') ? 0 : s:current_winnr
	let s:current_bufnr = bufnr("")
	let s:current_type = type

	" workaround for difficulties handling pattern and line number
	" matches together
	for i in editqf#Getlist(s:current_winnr, s:current_type)
		let pattern = i.pattern
		if pattern != '' && len(pattern) >= 5
			let pattern = pattern[3:-3]
		else
			let pattern = '3MPT1'
		endif
		let type = i.type
		if i.type == ''
			let type = 'E'
		endif
		call add(items, bufname(i.bufnr) . ':' . type . ':' . i.lnum . ':' . i.col . ':' . pattern . ':' . i.text)
	endfor
	call append(0, items)
	normal Gdd

	augroup qfbuffer
		au!
		au BufWriteCmd <buffer> call editqf#Cleanup(1)
		au BufLeave <buffer> call editqf#Cleanup(0)
	augroup END

	" prevent text from being wrapped
	setlocal tw=0 fo-=trwnaocl
endfunction

function! editqf#ChangeType(...)
	" change the type of the quickfix entry the cursor is currently on
	let l:line = line(".")
	let l:col = col(".") - 1
	let l:qf = getqflist()
	let l:types = ['I', 'W', 'E']

	if len(l:qf) < l:line
		return
	endif

	" change type of current error
	if a:0 >= 1
		if index(l:types, a:1) >= 0
			let l:qf[l:line - 1]['type'] = a:1
		else
			let l:qf[l:line - 1]['type'] = l:types[(index(l:types, l:qf[l:line - 1]['type']) + a:1) % len(l:types)]
		endif
	else
		let l:qf[l:line - 1]['type'] = l:types[(index(l:types, l:qf[l:line - 1]['type']) + 1) % len(l:types)]
	endif
	call setqflist(l:qf, 'r')
	exec "normal ".l:line."G0" . l:col . "l"
endfunction
