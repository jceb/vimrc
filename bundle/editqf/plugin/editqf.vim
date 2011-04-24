" editqf.vim -- make quickfix entries editable
" Author:         Jan Christoph Ebersbach (jceb@e-jc.de)
" License:        GPL (see http://www.gnu.org/licenses/gpl.txt)
" Created:        2008-11-28
" Last Modified:  Sat 23. Apr 2011 21:11:17 +0900 JST
" Revision:       1.1
" vi:             ft=vim:tw=80:sw=4:ts=8
"
" Description:
" This script is a reimplementation and continuation of the QuickFixNotes
" script (http://www.vim.org/scripts/script.php?script_id=2216). Besides the
" original functionality of capturing notes and storing them in a file, this
" script provides commands for easily loading the stored data, also for
" location lists.
"
" Though the main functionality of this script is to make editing of quickfix
" entries easy.
"
" This script can be downloaded from https://github.com/jceb/vim-editqf
"
" Usage:
" Create entries in the quickfix list by either running special a command
" like :make or :grep or add a note by pressing <leader>n. Then bring up the
" quickfix window by running the command :cw.
"
" When you are in the quickfix window navigate to the entry you want to
" change. Just press any key that would bring in into insert mode or change
" the text like "i".  Automatically a new window will be opened containing
" all entries of the quickfix window.
"
" You can use the regular editing commands for editing the entries. Once
" you're done, just save the buffer and leave or close the window. I
" recommend using :x, because this command does both with just one command.
" After that you are brought back to the error you initially started editing
" in the quickfix window.
"
" Additionally the plugin provides the following commands that support
" storing and restoring quickfix and location lists:
" 	:SaveQF <FILENAME>
" 	:LoadQF <FILENAME>  " default is to append to the current quickfix list
" 	:LoadQF! <FILENAME> " replace quickfix list with the contents of file
" 	:AddNoteQF [NOTE]   " add quickfix entry with message NOTE
" 	:AddNoteQF! [NOTE]  " like :AddNoteQF but start a new quickfix list
" 	:AddNoteQFPattern[!] [NOTE]   " add quickfix entry matching the pattern of the current line
"
" 	:SaveLoc <FILENAME>
" 	:LoadLoc <FILENAME>  " default is to append to the current location list
" 	:LoadLoc! <FILENAME> " replace location list with the contents of file
" 	:AddNoteLoc [NOTE]   " add location entry with message NOTE
" 	:AddNoteLoc! [NOTE]  " like :AddNoteLoc but start a new location list
" 	:AddNoteLocPattern[!] [NOTE]   " add location entry matching the pattern of the current line
"
" Editqf has integrated support for the hier script
" (http://www.github.com/jceb/vim-hier) which highlights quickfix errors to
" make them more visible.
" Customization:
" The default filename for storing and loading quickfix and location lists is
" customizable by setting the following variables in your vimrc:
" 	let g:editqf_saveqf_filename  = "quickfix.list"
" 	let g:editqf_saveloc_filename = "location.list"
"
" Jump to the edited error when editing finished:
" 	let g:editqf_jump_to_error    = 1
"
" The default keybinding <leader>n for adding a quickfix note can be
" customized by defining a mapping in your vimrc:
" 	nmap <leader>n <Plug>AddNoteQF
" 	nmap <leader>N <Plug>AddNoteQFPattern
" 	nmap <leader>l <Plug>AddNoteLoc
" 	nmap <leader>L <Plug>AddNoteLocPattern
"
" Installation Details:
" 1. Download editqf.vim
" 2. Move file to $HOME/.vim/plugin
" 3. Restart vim
"
" Known Issues:
" - When trying to edit a location list the quickfix list is opened instead!
"   This is because it's not possible to tell the difference between a
"   quickfix and a location list from vim script. A workaround is to open the
"   location list manually: :e loc:list
" - When opening a location list (filename loc:list) in a new window the
"   location list of that window is opened instead! Location lists should
"   always be edited by running :e loc:list. Once editing finished C-^
"   should be used to leave the location list and go back to the last edited
"   buffer
" - Mapping <Plug>AddNoteQFPattern and <Plug>AddNoteLocPattern doesn't work
"   quite well because vim seems to execute <Plug>AddNoteQF with paramter
"   Pattern instead
"
" Changelog:
" 1.1
" - improve support for hier script
" - add g:editqf_jump_to_error variablew to make jumping to the last selected
"   error optional
" - prefix save-filename variable with plugin name
" - move all functionality from Edit to Read function to allow editing of
"   qf:list and loc:list directly through vim commands (:e, :sp ...)
" - add support for patterns matching instead of line numbers
" - add description of quickfix/location fields to the editing buffer
" - fix issue when deleting all entries from quickfix/location list
"
" 1.0
" - initial release

if &cp || exists("loaded_editqf")
    finish
endif
let loaded_editqf = 1

if !exists("g:editqf_saveqf_filename")
	let g:editqf_saveqf_filename = "quickfix.list"
endif

if !exists("g:editqf_saveloc_filename")
	let g:editqf_saveloc_filename = "location.list"
endif

if !exists("g:editqf_jump_to_error")
	let g:editqf_jump_to_error = 1
endif

command -nargs=* -bang AddNoteQF :call <SID>AddNote("qf", 'l', <f-args>)
command -nargs=* -bang AddNoteQFPattern :call <SID>AddNote("qf", 'p', <f-args>)
command -nargs=? -bang -complete=file SaveQF :call <SID>Save("qf", <f-args>)
command -nargs=? -bang -complete=file LoadQF :call <SID>Load("qf", <f-args>)

command -nargs=* -bang AddNoteLoc :call <SID>AddNote("loc", 'l', <f-args>)
command -nargs=* -bang AddNoteLocPattern :call <SID>AddNote("loc", 'p', <f-args>)
command -nargs=? -bang -complete=file SaveLoc :call <SID>Save("loc", <f-args>)
command -nargs=? -bang -complete=file LoadLoc :call <SID>Load("loc", <f-args>)

nmap <Plug>AddNoteQF :AddNoteQF<CR>
nmap <Plug>AddNoteLoc :AddNoteLoc<CR>

if ! hasmapto("<Plug>AddNoteQF", "n")
	nmap <leader>n <Plug>AddNoteQF
endif

if ! hasmapto("<Plug>AddNoteQFPattern", "n")
	"nmap <leader>p <Plug>AddNoteQFPattern
	" workaround for a vim bug
	nmap <leader>N :AddNoteQFPattern<CR>
endif

function! s:Getlist(winnr, type)
	if a:type == 'qf'
		return getqflist()
	else
		return getloclist(a:winnr)
	endif
endfunction

function! s:Setlist(winnr, type, list, action)
	if a:type == 'qf'
		call setqflist(a:list, a:action)
	else
		call setloclist(a:winnr, a:list, a:action)
	endif
endfunction

function! <SID>AddNote(type, matchtype, ...)
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
		let note = input("Enter Note: ")
	endif
	if note == ""
		return
	endif

	let entry = {}
	let entry["bufnr"]    = bufnr("%")
	let entry["filename"] = expand("%:p")
	let entry["lnum"]     = ""
	let entry["col"]      = ""
	let entry["pattern"]  = ""
	if a:matchtype == 'l'
		let entry["lnum"]     = line(".")
		let entry["col"]      = col(".")
	else
		let entry["pattern"]  = '^\V'.getline('.').'\$'
	endif
	let entry["vcol"]     = ""
	"let entry["nr"]       = 0
	let entry["text"]     = note
	let entry["type"]     = "E"

	if v:cmdbang == 1
		call s:Setlist(0, a:type, [entry], "r")
	else
		call s:Setlist(0, a:type, [entry], "a")
	endif

	if exists(':HierUpdate')
		HierUpdate
	endif
endfunction

function! <SID>Save(type, ...)
	let file = a:type == "qf" ? g:editqf_saveqf_filename : g:editqf_saveloc_filename
	if a:0 > 1
		let file = a:1
	endif

	if (filewritable(file) && v:cmdbang == 1) || ! exists(file)
		let items = []
		let winnr = a:type == 'qf' ? '' : 0
		for i in s:Getlist(winnr, a:type)
			let pattern = i.pattern
			if pattern != '' && len(pattern) >= 5
				let pattern = pattern[3:-3]
			else
				let pattern = '3MPT1'
			endif
			call add(items, bufname(i.bufnr) . ':' . i.type . ':' . i.lnum . ':' . i.col . ':' . pattern . ':' . i.text)
		endfor
		call writefile(items, fnameescape(file))
	else
		echoerr "Unable to write file " . file
	endif
endfunction

function! <SID>Load(type, ...)
	let file = g:editqf_saveqf_filename
	let get = a:type == "qf" ? "caddfile" : "laddfile"
	if v:cmdbang == 1
		let get = a:type == "qf" ? "cgetfile" : "lgetfile"
	endif

	if a:0 > 0
		let file = a:1
	endif

	if filereadable(file)
			let tmp_efm = &efm
			" set efm to the format used to store errors in a file
			set efm=%f:%t:%l:%c:%s:%m
			exec get." ".file
			let &efm=tmp_efm

			let l = []
			let found_empty_pattern = 0
			for i in s:Getlist(0, a:type)
				if i.pattern == '^\V3MPT1\$'
					unlet i.pattern
					let found_empty_pattern = 1
				endif
				call add(l, i)
			endfor
			if found_empty_pattern == 1
				call s:Setlist(0, a:type, l, 'r')
			endif
	else
		echoerr "Unable to open file " . file
	endif

	if exists(':HierUpdate')
		HierUpdate
	endif
endfunction

function! <SID>Cleanup(loadqf)
	if ! exists("s:current_bufnr") || ! bufexists(s:current_bufnr)
		return
	endif
	let get = s:current_type == 'qf' ? 'cgetbuffer' : 'lgetbuffer'

	" delete every empty line - empty lines cause empty entries in quickfix
	" list
	silent! g/^\s*$/d
	silent! g/^bufnr:/d

	let empty_list = 0
	if getline(1) == ""
		let empty_list = 1
		call s:Setlist(s:current_winnr, s:current_type, [], 'r')
	endif

	if a:loadqf == 0
		" close quickfix window
		au! qfbuffer
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

			let l = []
			let found_empty_pattern = 0
			let winnr = s:current_type == 'loc'? s:current_winnr : ''

			for i in s:Getlist(winnr, s:current_type)
				if i.pattern == '^\V3MPT1\$'
					unlet i.pattern
					let found_empty_pattern = 1
				endif
				call add(l, i)
			endfor
			if found_empty_pattern == 1
				call s:Setlist(s:current_winnr, s:current_type, l, "r")
			endif
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

function! <SID>Edit()
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

	" move cursor to the column it was in in the quickfix window
	exec "normal ".line."G0" . col . "l"
endfunction

function! <SID>Read(fname)
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
	for i in s:Getlist(s:current_winnr, s:current_type)
		let pattern = i.pattern
		if pattern != '' && len(pattern) >= 5
			let pattern = pattern[3:-3]
		else
			let pattern = '3MPT1'
		endif
		call add(items, bufname(i.bufnr) . ':' . i.type . ':' . i.lnum . ':' . i.col . ':' . pattern . ':' . i.text)
	endfor
	call append(0, items)
	normal Gdd

	augroup qfbuffer
		au BufWriteCmd <buffer> call <SID>Cleanup(1)
		au BufLeave <buffer> call <SID>Cleanup(0)
	augroup END

	" prevent text from being wrapped
	setlocal tw=0 fo-=trwnaocl
endfunction

augroup qf
	au BufReadCmd qf:list call <SID>Read(expand("<amatch>"))
	au BufReadCmd loc:list call <SID>Read(expand("<amatch>"))
augroup END

for i in ["i", "a", "c", "o", "p", "r", "s", "d", "x", "I", "A", "C", "O", "P", "R", "S", "D", "X"]
	exec "au qf BufReadPost quickfix nnoremap <silent> <buffer> ".i." :if !exists('s:current_bufnr')<Bar>call <SID>Edit()<Bar>endif<CR>"
endfor
