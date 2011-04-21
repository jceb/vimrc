" editqf.vim -- make quickfix entries editable
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2008-11-28
" @Last Modified: Thu 21. Apr 2011 13:52:50 +0900 JST
" @Revision     : 1.0
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  :
"  DESCRIPTION:
"  This script is a reimplementation and continuation of the QuickFixNotes
"  script (http://www.vim.org/scripts/script.php?script_id=2216). Besides the
"  original functionality of capturing notes and storing them in a file, this
"  script provides commands for easily loading the stored data, also for
"  location lists.
"
"  Though the main functionality of this script is to make editing of quickfix
"  entries easy.
"
"  This script can be downloaded from https://github.com/jceb/vim-editqf
"
"  USAGE:
"  Create entries in the quickfix list by either running special a command
"  like :make or :grep or add a note by pressing <leader>n. Then bring up the
"  quickfix window by running the command :cw.
"
"  When you are in the quickfix window navigate to the entry you want to
"  change. Just press any key that would bring in into insert mode or change
"  the text like "i".  Automatically a new window will be opened containing
"  all entries of the quickfix window.
"
"  You can use the regular editing commands for editing the entries. Once
"  you're done, just save the buffer and leave or close the window. I
"  recommend using :x, because this command does both with just one command.
"  After that you are brought back to the error you initially started editing
"  in the quickfix window.
"
"  Additionally the plugin provides the following commands that support
"  storing and restoring quickfix and location lists:
"  	:SaveQF <FILENAME>
"  	:LoadQF <FILENAME>  " default is to append to the current quickfix list
"  	:LoadQF! <FILENAME> " replace quickfix list with the contents of file
"  	:AddNoteQF [NOTE]   " add quickfix entry with message NOTE
"  	:AddNoteQF! [NOTE]  " like :AddNoteQF but start a new quickfix list
"
"  	:SaveLoc <FILENAME>
"  	:LoadLoc <FILENAME>  " default is to append to the current location list
"  	:LoadLoc! <FILENAME> " replace location list with the contents of file
"  	:AddNoteLoc [NOTE]   " add location entry with message NOTE
"  	:AddNoteLoc! [NOTE]  " like :AddNoteLoc but start a new location list
"
" CUSTOMIZATION:
" The default filename for storing and loading quickfix and location lists is
" customizable by setting the following variables in your vimrc:
" 	let g:saveqf_filename = "quickfix.list"
" 	let g:saveloc_filename = "location.list"
"
" The default keybinding <leader>n for adding a quickfix note can be
" customized by defining a mapping in your vimrc:
" 	nmap <leader>n <Plug>AddNoteQF
" 	nmap <leader>l <Plug>AddNoteLoc
"
" INSTALLATION DETAILS:
" 1. Download editqf.vim
" 2. Move file to $HOME/.vim/plugin
" 3. Restart vim

if &cp || exists("loaded_editqf")
    finish
endif
let loaded_editqf = 1

if !exists("g:saveqf_filename")
	let g:saveqf_filename = "quickfix.list"
endif

if !exists("g:saveloc_filename")
	let g:saveloc_filename = "location.list"
endif

command -nargs=* -bang AddNoteQF :call <SID>AddNote("qf", <f-args>)
command -nargs=? -bang -complete=file SaveQF :call <SID>Save("qf", <f-args>)
command -nargs=? -bang -complete=file LoadQF :call <SID>Load("qf", <f-args>)

command -nargs=* -bang AddNoteLoc :call <SID>AddNote("loc", <f-args>)
command -nargs=? -bang -complete=file SaveLoc :call <SID>Save("loc", <f-args>)
command -nargs=? -bang -complete=file LoadLoc :call <SID>Load("loc", <f-args>)

nmap <Plug>AddNoteQF :AddNoteQF<CR>
nmap <Plug>AddNoteLoc :AddNoteLoc<CR>

if ! hasmapto("<Plug>AddNoteQF", "n")
	nmap <leader>n <Plug>AddNoteQF
endif

function! <SID>AddNote(type, ...)
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
	let entry["lnum"]     = line(".")
	"let entry["pattern"]  = ""
	let entry["col"]      = col(".")
	let entry["vcol"]     = ""
	"let entry["nr"]       = 0
	let entry["text"]     = note
	let entry["type"]     = "E"

	if v:cmdbang == 1
		if a:type == "qf"
			call setqflist([entry], "r")
		else
			call setloclist(0, [entry], "r")
		endif
	else
		if a:type == "qf"
			call setqflist([entry], "a")
		else
			call setloclist(0, [entry], "a")
		endif
	endif
endfunction

function! <SID>Save(type, ...)
	let file = g:saveqf_filename
	if a:type == "loc"
		let file = g:saveloc_filename
	endif
	if a:0 > 1
		let file = a:1
	endif

	if (filewritable(file) && v:cmdbang == 1) || ! exists(file)
		let items = []
		if a:type == "qf"
			for i in getqflist()
				call add(items, bufname(i.bufnr) . ":" . i.type . ":" . i.lnum . ":" . i.col . ":" . i.text)
			endfor
		else
			for i in getloclist(0)
				call add(items, bufname(i.bufnr) . ":" . i.type . ":" . i.lnum . ":" . i.col . ":" . i.text)
			endfor
		endif
		call writefile(items, file)
	else
		echoerr "Unable to write file " . file
	endif
endfunction

function! <SID>Load(type, ...)
	let file = g:saveqf_filename
	let get = "caddfile"
	if a:type == "loc"
		let get = "laddfile"
	endif
	if v:cmdbang == 1
		let get = "cgetfile"
		if a:type == "loc"
			let get = "lgetfile"
		endif
	endif

	if a:0 > 0
		let file = a:1
	endif

	if filereadable(file)
			let tmp_efm = &efm
			" set efm to the format used to store errors in a file
			set efm=%f:%t:%l:%c:%m
			exec get." ".file
			let &efm=tmp_efm
	else
		echoerr "Unable to open file " . file
	endif
endfunction

function! <SID>Cleanup(type, loadqf, line)
	if ! exists("s:bufnr") || ! bufexists(s:bufnr)
		return
	endif
	if a:loadqf == 0
		au! qfbuffer
		exec "bw! ".s:bufnr
		exec "cc ".a:line
		unlet! s:bufnr
	else
		let tmp_efm = &efm
		" set efm to the format used to store errors in a file
		set efm=%f:%t:%l:%c:%m
		if a:type == "qf"
			exec "cgetbuffer ".s:bufnr
		else
			exec "lgetbuffer ".s:bufnr
		endif
		let &efm=tmp_efm
		set nomodified
	endif
endfunction

function! <SID>Edit(type)
	let line = line(".")
	let col = col(".") - 1
	exec "silent! ".winheight(0)."sp"
	if a:type == "qf"
		e quickfix:list
	else
		" WARNING: unfortunately it's not possible to determine the difference between
		" quickfix and location list from within vim script. When editing a
		" location list the quickfix list is edited instead
		e location:list
	endif
	exec "normal ".line."G0" . col . "l"
	setlocal tw=0
	let s:bufnr = bufnr("")
	augroup qfbuffer
	exec "au qfbuffer BufWriteCmd <buffer> call <SID>Cleanup('".a:type."', 1, ".line.")"
	exec "au qfbuffer BufLeave <buffer> call <SID>Cleanup('".a:type."', 0, ".line.")"
endfunction

function! <SID>Read(fname)
	let items = []
	if a:fname =~ 'quickfix:'
		for i in getqflist()
			call add(items, bufname(i.bufnr) . ":" . i.type . ":" . i.lnum . ":" . i.col . ":" . i.text)
		endfor
	else
		for i in getloclist(0)
			call add(items, bufname(i.bufnr) . ":" . i.type . ":" . i.lnum . ":" . i.col . ":" . i.text)
		endfor
	endif
	call append(0, items)
	normal Gdd
endfunction

augroup qf
	au BufReadCmd quickfix:* call <SID>Read(expand("<amatch>"))
	au BufReadCmd location:* call <SID>Read(expand("<amatch>"))
	if has("unix")
		au BufReadCmd quickfix:*/* call <SID>Read(expand("<amatch>"))
		au BufReadCmd location:*/* call <SID>Read(expand("<amatch>"))
	endif
augroup END

for i in ["i", "a", "c", "o", "p", "r", "s", "d", "x", "I", "A", "C", "O", "P", "R", "S", "D", "X"]
	exec "au qf BufReadPost quickfix nnoremap <silent> <buffer> ".i." :if !exists('s:bufnr')<Bar>call <SID>Edit('qf')<Bar>endif<CR>"
endfor
