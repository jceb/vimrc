" diff2qf.vim -- generate a quickfix list from a patch
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2008-11-28
" @Last Modified: Fri 05. Mar 2010 17:51:55 +0100 CET
" @Revision     : 0.1
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  :
" @Usage        :
" @TODO         :
" @CHANGES      :

if &cp || exists("b:loaded_diff2qf")
    finish
endif
let b:loaded_diff2qf = 1

function! Diff2qflist (filename, ...)
	" variables are {filename} [{strip} [{linenumbers}]]
	" {strip} number of leading directories to strip off
	" {linenumbers} line numbers of hunks (1: original (default), 2: new)
	let qf = []
	let lines = readfile (expand(a:filename))
	let current_filename = ''
	let p = 1 " stripping of leading directories
	let linenumbers = 1 " using the original line number
	let hunk = 1
	if a:0 > 0
		let p = a:1
		if a:0 > 1
			let linenumbers = a:2
		endif
	endif
	if linenumbers == 2
		" use new line numbers of hunks
		let linenumbers = 2
	else
		" use original line numbers of hunks
		let linenumbers = 1
	endif
	let i = 0
	for l in lines
		if l =~ '^+++ '
			unlet! tmp f
			let tmp = split (l)[1]
			let f = []
			let hunk = 1
			while 1
				if tmp == '/'
					" '' is added because the path is joined with slashes later
					" on
					call add (f, '')
					break
				endif
				let t = fnamemodify(tmp, ':t')
				call add (f, t)
				let tmp2 = fnamemodify(tmp, ':h')
				if tmp2 == tmp || t == tmp
					break
				else
					let tmp = tmp2
				endif
			endwhile
			let current_filename = join(reverse(f[:-p-1]), '/')
		elseif current_filename != '' && l =~ '^@@ '
			unlet! tmp linenumber entry
			let linenumber = split(split(l)[linenumbers], ',')[0][1:]
			let entry = {}
			let entry["filename"] = current_filename
			let entry["lnum"] = linenumber
			let entry["text"] = 'Hunk #'.hunk.': '.lines[i+1][1:]
			let entry["type"] = 'E'
			let hunk = hunk + 1
			call add (qf, entry)
		endif
		let i = i + 1
	endfor
	return qf
endfunction

command! -complete=file -nargs=+ Diff2qf :exec setqflist (Diff2qflist(<f-args>), 'r')
command! -complete=file -nargs=+ Diff2qfAppend :exec setqflist (Diff2qflist(<f-args>), 'a')
