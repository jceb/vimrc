" diff2qf.vim -- generate a quickfix list from a patch
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2008-11-28
" @Last Modified: Sat 06. Mar 2010 19:30:35 +0100 CET
" @Revision     : 0.2
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Plugin to generate a quickfix list from a patch file
" @Usage        : :Diff2qf <file> [strip_leading_directories [hunk_line_numbers]]
"					strip_leading_directories: number of leading directories to strip off
"						(default: 1)
"					hunk_line_numbers: which line numbers to use for the hunks: 1 (original,
"						default), 2 (new)
"					or
" 		        :Diff2qfAppend <file> [strip_leading_directories [hunk_line_numbers]]
" @TODO         :
" @CHANGES      :

if &cp || exists("g:loaded_diff2qf")
    finish
endif
let g:loaded_diff2qf = 1

function! Diff2qflist (filename, ...)
	" variables are {filename} [{strip} [{linenumbers}]]
	" {strip} number of leading directories to strip off
	" {linenumbers} line number of hunks (1: original (default), 2: new)

	" quickfix list
	let qf = []

	" lines of input file
	let lines = readfile(expand(a:filename))

	" file of hunk
	let hunk_filename = ''

	" number of leading directories to strip
	let p = 1

	" line number to use for this patch file
	let linenumbers = 1

	" retrieve p and linenumbers from arguments
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

	" hunk number in patch file
	let hunk = 1

	" linenumber for the beginning of the current hunk
	let start_of_hunk = 0

	" indicates that a hunk has been started
	let hunk_started = 1

	" linenumber of the currently processed line
	let i = 0

	for l in lines
		" extract filename of hunk
		if l =~ '^+++ '
			unlet! tmp f description
			let tmp = split(l)[1]
			let f = []
			while 1
				if tmp == '/'
					" '' is added because the path is joined with slashes later
					" on
					call add(f, '')
					break
				endif
				let t = fnamemodify(tmp, ':t')
				call add(f, t)
				let tmp2 = fnamemodify(tmp, ':h')
				if tmp2 == tmp || t == tmp
					break
				else
					let tmp = tmp2
				endif
			endwhile
			let hunk_filename = join(reverse(f[:-p-1]), '/')
			if i - 2 > start_of_hunk
				for _l in lines[start_of_hunk : i-2]
					if _l !~ '^$' && _l !~ '^[\t ]' && _l !~# '^index ' && _l !~# '^diff '
						let description = _l
						break
					endif
				endfor
			endif
		elseif hunk_filename != '' && l =~ '^@@ '
			" add new hunk to qf list
			unlet! tmp linenumber entry
			let linenumber = split(split(l)[linenumbers], ',')[0][1:]
			let entry = {}
			let entry["filename"] = hunk_filename
			let entry["lnum"] = linenumber
			if exists('description')
				let entry["text"] = 'Hunk #'.hunk.': '.description
			else
				let entry["text"] = 'Hunk #'.hunk.': '.lines[i+1][1:]
			endif
			let entry["type"] = 'E'
			let hunk += 1
			let hunk_started = 0
			call add(qf, entry)
		else
			" seek the beginning of a hunk
			if l !~ '^[+\- ]' && l !~ '^@@ ' && hunk_started == 0
				let start_of_hunk = i
				let hunk_started = 1
			endif
		endif
		let i += 1
	endfor
	return qf
endfunction

command! -complete=file -nargs=+ Diff2qf :exec setqflist(Diff2qflist(<f-args>), 'r')
command! -complete=file -nargs=+ Diff2qfAppend :exec setqflist(Diff2qflist(<f-args>), 'a')
