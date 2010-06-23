" LaTeX Box motion functions

" begin/end pairs {{{
function! s:JumpToMatch(mode)

	" selection is lost upon function call, reselect
	if a:mode == 'v'
		normal! gv
	endif

	let open_pats = ['{', '\[', '(', '\\begin\>', '\\left\>']
	let close_pats = ['}', '\]', ')', '\\end\>', '\\right\>']

	"for [open_pat, close_pat] in [['\\begin\>', '\\end\>'], ['\\left\>', '\\right\>']]

	let filter = 'strpart(getline("."), 0, col(".") - 1) =~ ''^%\|[^\\]%'''

	" move to the left until not on alphabetic characters
	let [bufnum, lnum, cnum, off] = getpos('.')
	let line = getline(lnum)
	while cnum > 1 && line[cnum - 1] =~ '\a'
		let cnum -= 1
	endwhile
	call cursor(lnum, cnum)

	" go to next opening/closing pattern
	call search(join(open_pats + close_pats, '\|'), 'cW', filter)

	let rest_of_line = strpart(line, col('.') - 1)

	for i in range(len(open_pats))
		let open_pat = open_pats[i]
		let close_pat = close_pats[i]

		if rest_of_line =~ '^\%(' . open_pat . '\)'
			" if on opening pattern, go to closing pattern
			call searchpair(open_pat, '', close_pat, 'W', filter)
			return
		elseif rest_of_line =~ '^\%(' . close_pat . '\)'
			" if on closing pattern, go to opening pattern
			let flags = 'bW'
			call searchpair(open_pat, '', close_pat, 'bW', filter)
			return
		endif

	endfor

endfunction
nnoremap <silent> <Plug>LatexBox_JumpToMatch :call <SID>JumpToMatch('n')<CR>
vnoremap <silent> <Plug>LatexBox_JumpToMatch :<C-U>call <SID>JumpToMatch('v')<CR>
" }}}

" select current environment {{{
function! s:SelectCurrentEnv(seltype)
	let [env, lnum, cnum, lnum2, cnum2] = LatexBox_GetCurrentEnvironment(1)
	call cursor(lnum, cnum)
	if a:seltype == 'inner'
		if env =~ '^\'
			normal! 2l
		else
			call search('}\_\s*', 'eW')
			normal l
		endif
	endif
	if visualmode() ==# 'V'
		normal! V
	else
		normal! v
	endif
	call cursor(lnum2, cnum2)
	if a:seltype == 'inner'
		call search('\S\_\s*', 'bW')
	else
		if env =~ '^\'
			normal! 2l
		else
			call search('}', 'eW')
		endif
	endif
endfunction
vnoremap <silent> <Plug>LatexBox_SelectCurrentEnvInner :<C-U>call <SID>SelectCurrentEnv('inner')<CR>
vnoremap <silent> <Plug>LatexBox_SelectCurrentEnvOuter :<C-U>call <SID>SelectCurrentEnv('outer')<CR>
" }}}

" Jump to the next braces {{{
"
function! LatexBox_JumpToNextBraces(backward)
	let flags = ''
	if a:backward
		normal h
		let flags .= 'b'
	else
		let flags .= 'c'
	endif
	if search('[][}{]', flags) > 0
		normal l
	endif
	let prev = strpart(getline('.'), col('.') - 2, 1)
	let next = strpart(getline('.'), col('.') - 1, 1)
	if next =~ '[]}]' && prev !~ '[][{}]'
		return "\<Right>"
	else
		return ''
	endif
endfunction
" }}}

" Table of Contents {{{
function! s:ReadTOC(auxfile)

	let toc = []

	let prefix = fnamemodify(a:auxfile, ':p:h')

	for line in readfile(a:auxfile)

		let included = matchstr(line, '^\\@input{\zs[^}]*\ze}')
		
		if included != ''
			call extend(toc, s:ReadTOC(prefix . '/' . included))
			continue
		endif

		let m = matchlist(line,
					\ '^\\@writefile{toc}{\\contentsline\s*' .
					\ '{\([^}]*\)}{\\numberline {\([^}]*\)}\(.*\)')

		if !empty(m)
			let str = m[3]
			let nbraces = 0
			let istr = 0
			while nbraces >= 0 && istr < len(str)
				if str[istr] == '{'
					let nbraces += 1
				elseif str[istr] == '}'
					let nbraces -= 1
				endif
				let istr += 1
			endwhile
			let text = str[:(istr-2)]
			let page = matchstr(str[(istr):], '{\([^}]*\)}')

			call add(toc, {'file': fnamemodify(a:auxfile, ':r') . '.tex',
						\ 'level': m[1], 'number': m[2], 'text': text, 'page': page})
		endif

	endfor

	return toc

endfunction

function! LatexBox_TOC()
	let toc = s:ReadTOC(LatexBox_GetAuxFile())
	let calling_buf = bufnr('%')

	30vnew +setlocal\ buftype=nofile LaTeX\ TOC

	for entry in toc
		call append('$', entry['number'] . "\t" . entry['text'])
	endfor
	call append('$', ["", "<Esc>/q: close", "<Space>: jump", "<Enter>: jump and close"])

	0delete
	syntax match Comment /^<.*/

	map <buffer> <silent> q			:bdelete<CR>
	map <buffer> <silent> <Esc>		:bdelete<CR>
	map <buffer> <silent> <Space> 	:call <SID>TOCActivate(0)<CR>
	map <buffer> <silent> <CR> 		:call <SID>TOCActivate(1)<CR>
	setlocal cursorline nomodifiable tabstop=8 nowrap

	let b:toc = toc
	let b:calling_win = bufwinnr(calling_buf)

endfunction

" TODO
"!function! s:FindClosestSection(toc, pos)
"!	let saved_pos = getpos('.')
"!	for entry in toc
"!	endfor
"!
"!	call setpos(saved_pos)
"!endfunction

function! s:TOCActivate(close)
	let n = getpos('.')[1] - 1

	if n >= len(b:toc)
		return
	endif

	let entry = b:toc[n]

	let toc_bnr = bufnr('%')
	let toc_wnr = winnr()

	execute b:calling_win . 'wincmd w'

	let bnr = bufnr(entry['file'])
	if bnr >= 0
		execute 'buffer ' . bnr
	else
		execute 'edit ' . entry['file']
	endif

	let titlestr = entry['text']

	" Credit goes to Marcin Szamotulski for the following fix. It allows to match through
	" commands added by TeX.
	let titlestr = substitute(titlestr, '\\\w*\>\s*\%({[^}]*}\)\?', '.*', 'g')

	let titlestr = escape(titlestr, '\')
	let titlestr = substitute(titlestr, ' ', '\\_\\s\\+', 'g')

	call search('\\' . entry['level'] . '\_\s*{' . titlestr . '}', 'w')
	normal zt

	if a:close
		execute 'bdelete ' . toc_bnr
	else
		execute toc_wnr . 'wincmd w'
	endif
endfunction
" }}}

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4
