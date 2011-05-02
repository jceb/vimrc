" hier.vim:		Highlight quickfix errors
" Last Modified: Tue 26. Apr 2011 15:53:25 +0900 JST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		1.1

if (exists("g:loaded_hier") && g:loaded_hier) || &cp
    finish
endif
let g:loaded_hier = 1

hi QFError    term=undercurl cterm=undercurl gui=undercurl guisp=Red
hi QFWarning  term=undercurl cterm=undercurl gui=undercurl guisp=Yellow
hi QFInfo     term=undercurl cterm=undercurl gui=undercurl guisp=Green

hi LocError    term=underline cterm=underline gui=underline guisp=Red
hi LocWarning  term=underline cterm=underline gui=underline guisp=Yellow
hi LocInfo     term=underline cterm=underline gui=underline guisp=Green

let g:hier_highlight_group_qf = ! exists('g:hier_highlight_group_qf') ? 'QFError' : g:hier_highlight_group_qf
let g:hier_highlight_group_qfw = ! exists('g:hier_highlight_group_qfw') ? 'QFWarning' : g:hier_highlight_group_qfw
let g:hier_highlight_group_qfi = ! exists('g:hier_highlight_group_qfi') ? 'QFInfo' : g:hier_highlight_group_qfi

let g:hier_highlight_group_loc = ! exists('g:hier_highlight_group_loc') ? 'LocError' : g:hier_highlight_group_loc
let g:hier_highlight_group_locw = ! exists('g:hier_highlight_group_locw') ? 'LocWarning' : g:hier_highlight_group_locw
let g:hier_highlight_group_loci = ! exists('g:hier_highlight_group_loci') ? 'LocInfo' : g:hier_highlight_group_loci

let g:hier_enabled = ! exists('g:hier_enabled') ? 1 : g:hier_enabled

function! s:Hier()
	if exists('b:hier_matches')
		for m in b:hier_matches
			silent! call matchdelete(m)
		endfor
		unlet b:hier_matches
	endif

	if g:hier_enabled == 0
		return
	endif

	let bufnr = bufnr('%')

	let b:hier_matches = []

	for i in getqflist()
		if i.bufnr == bufnr
			let hi_group = g:hier_highlight_group_qf
			if i.type == 'I'
				if g:hier_highlight_group_qfi != ""
					let hi_group = g:hier_highlight_group_qfi
				else
					continue
				endif
			endif
			if i.type == 'W'
				if g:hier_highlight_group_qfw != ""
					let hi_group = g:hier_highlight_group_qfw
				else
					continue
				endif
			endif
			if g:hier_highlight_group_qf == ""
				continue
			endif

			if i.lnum > 0
				call add(b:hier_matches, matchadd(hi_group, '\%'.i.lnum.'l'))
			elseif i.pattern != ''
				call add(b:hier_matches, matchadd(hi_group, i.pattern))
			endif
		endif
	endfor
	for i in getloclist(0)
		if i.bufnr == bufnr
			let hi_group = g:hier_highlight_group_loc
			if i.type == 'I'
				if g:hier_highlight_group_loci != ""
					let hi_group = g:hier_highlight_group_loci
				else
					continue
				endif
			endif
			if i.type == 'W'
				if g:hier_highlight_group_locw != ""
					let hi_group = g:hier_highlight_group_locw
				else
					continue
				endif
			endif
			if g:hier_highlight_group_loc == ""
				continue
			endif

			if i.lnum > 0
				call add(b:hier_matches, matchadd(hi_group, '\%'.i.lnum.'l'))
			elseif i.pattern != ''
				call add(b:hier_matches, matchadd(hi_group, i.pattern))
			endif
		endif
	endfor
endfunction

command! -nargs=0 HierUpdate call s:Hier()
command! -nargs=0 HierClear HierUpdate

command! -nargs=0 HierStart let g:hier_enabled = 1 | HierUpdate
command! -nargs=0 HierStop let g:hier_enabled = 0 | HierClear

augroup Hier
	au!
	au QuickFixCmdPost,BufEnter,WinEnter * :HierUpdate
augroup END
