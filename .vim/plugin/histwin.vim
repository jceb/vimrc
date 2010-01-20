" histwin.vim - Vim global plugin for browsing the undo tree
" -------------------------------------------------------------
" Last Change: 2010, Jan 19
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Version:     0.2
" Copyright:   (c) 2009 by Christian Brabandt
"              The VIM LICENSE applies to histwin.vim 
"              (see |copyright|) except use "histwin.vim" 
"              instead of "Vim". No warranty, express 
"              or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: enable GLVS:

" Init:"{{{
if exists("g:loaded_undo_browse") || &cp
	 finish
endif

let g:loaded_undo_browse=1
let s:cpo=&cpo
set cpo&vim

" Show help banner?
" per default enabled, you can change it,
" if you set g:undobrowse_help to 0 e.g.
" put in your .vimrc
" :let g:undobrowse_help=0
let s:undo_help=(exists("g:undobrowse_help") ? (g:undobrowse_help) : 
		\(exists("s:undo_help") ? s:undo_help : 1) )"}}}


" Functions:"{{{
fu! <sid>Init()"{{{
	if !exists("b:undo_tagdict")
	let b:undo_tagdict={}
	endif
	if !exists("s:undo_winname")
	let s:undo_winname='Undo_Tree'
	endif
	let s:orig_buffer = bufname('')
endfu"}}}

fu! <sid>ReturnHistList()"{{{
	let histlist=[]
	redir => a
	sil :undol
	redir end
	" First item contains the header
	let templist=split(a, '\n')[1:]
	for item in templist
		let change	=  matchstr(item, '^\s\+\zs\d\+') + 0
	let nr		=  matchstr(item, '^\s\+\d\+\s\+\zs\d\+') + 0
	let time	=  matchstr(item, '^\%(\s\+\d\+\)\{2}\s\+\zs.*$')
	if time !~ '\d\d:\d\d:\d\d'
	   let time=matchstr(time, '^\d\+')
		   let time=strftime('%H:%M:%S', localtime()-time)
	endif
	   call add(histlist, {'change': change, 'number': nr, 'time': time})
	endfor
	return histlist
endfu"}}}

fu! <sid>HistWin()"{{{
	let undo_buf=bufwinnr('^'.s:undo_winname.'$')
	if undo_buf != -1
		exe 'noa ' . undo_buf . 'wincmd w'
	else
	execute "40vsp " . s:undo_winname
	setl noswapfile buftype=nofile bufhidden=delete foldcolumn=0 nobuflisted nospell
		let undo_buf=bufwinnr("")
	endif
	exe 'noa ' . bufwinnr(s:orig_buffer) . ' wincmd w'
	return undo_buf
endfu"}}}

fu! <sid>PrintUndoTree(winnr)"{{{
	let bufname=(empty(s:orig_buffer) ? '[No Name]' : fnamemodify(s:orig_buffer,':t'))
	exe 'noa' . a:winnr . 'wincmd w'
	let save_cursor=getpos('.')
	setl modifiable
	%d _
	let histlist = getbufvar(s:orig_buffer, 'undo_list')
	let tagdict  = getbufvar(s:orig_buffer, 'undo_tagdict')
	call setline(1,'Undo-Tree: '.bufname)
	put =repeat('=', strlen(getline(1)))
	put =''
	if !empty(histlist)
	call <sid>PrintHelp(s:undo_help)
	call append('$', printf("%s %-10s %s", "Nr", "   Time", "Tag"))
	let i=1
	for line in histlist
		let tag = get(tagdict, i-1, '')
		let tag = (empty(tag) ? tag : '/'.tag.'/')
		call append('$', 
		\ printf("%0*d) %8s %s", 
		\ strlen(len(histlist)), i, line['time'], 
		\ tag ))
		let i+=1
	endfor
	call <sid>MapKeys()
	else
	put ='No Undo Tree available'
	endif
	call <sid>HilightLines()
	setl nomodifiable
	call setpos('.', save_cursor)
endfu"}}}

fu! <sid>HilightLines()"{{{
	call matchadd('Title', '^\%1lUndo-Tree: \zs.*$')
	call matchadd('Comment', '^".*$')
	call matchadd('Identifier', '^\d\+\ze)')
	call matchadd('Special', '/\zs.*\ze/$')
	call matchadd('Ignore', '/$')
	call matchadd('Ignore', '/\ze.*/$')
	call matchadd('Underlined', '^\d\+)\s\+\zs\S\+')
endfu"}}}

fu! <sid>PrintHelp(...)"{{{
	if a:1
	put =\"\\"<Enter> goto undo branch\"
	put =\"\\"T\t Tag branch\"
	put =\"\\"R\t Replay branch\"
	put =\"\\"Q\t Quit window\"
	put =\"\\"I\t Toggle this help window\"
	else
	put =\"\\"I\t Toggle help window\"
	endif
	put =''
endfu"}}}

fu! <sid>MapKeys()"{{{
	noremap <script> <buffer> <expr> <CR> <sid>UndoBranch(<sid>ReturnBranch())
	noremap <script> <buffer> T :call <sid>UndoBranchTag(<sid>ReturnBranch())<CR>
	noremap <script> <buffer> I :call <sid>ToggleHelpScreen()<CR>
	noremap <script> <buffer> Q :q<CR>
	noremap <script> <buffer> R :call <sid>ReplayUndoBranch(<sid>ReturnBranch())<CR>
endfu"}}}

fu! <sid>ReplayUndoBranch(change)"{{{
	"noa wincmd p
	exe 'noa ' . bufwinnr(s:orig_buffer) . ' wincmd w'
	let end=b:undo_list[a:change-1]['number']
	exe ':u ' . b:undo_list[a:change-1]['change']
	exe 'normal ' . end . 'u' 
	redraw
	let start=1
	while start <= end
	red
	redraw
	sleep 100m
	let start+=1
	endw
endfu"}}}

fu! <sid>ReturnBranch()"{{{
	return matchstr(getline('.'), '^\d\+\ze')
endfu"}}}

fu! <sid>ToggleHelpScreen()"{{{
	let s:undo_help=!s:undo_help
	"noa wincmd p
	exe 'noa ' . bufwinnr(s:orig_buffer) . ' wincmd w'
	call <sid>PrintUndoTree(<sid>HistWin())
endfu"}}}

fu! <sid>UndoBranchTag(change)"{{{
	let tag=input(a:change . " Tagname: ")
	let tagdict=getbufvar(s:orig_buffer, 'undo_tagdict')
	let tagdict[a:change-1] = tag
	call setbufvar('#', 'undo_tagdict', tagdict)
	"noa wincmd p
	exe 'noa ' . bufwinnr(s:orig_buffer) . ' wincmd w'
	call <sid>PrintUndoTree(<sid>HistWin())
endfu"}}}

fu! <sid>UndoBranch(change)"{{{
	let histlist=getbufvar(s:orig_buffer, 'undo_list')
	if a:change > 0
	return bufwinnr(s:orig_buffer) . 'w:u '.histlist[a:change-1]['change'].'' . bufwinnr(s:orig_buffer) . 'w'
	else
		return ''
	endif
endfu"}}}

fu! <sid>UndoBrowse()"{{{
	call <sid>Init()
	let b:undo_list=<sid>ReturnHistList()
	let b:undo_win=<sid>HistWin()
	call <sid>PrintUndoTree(b:undo_win)
endfu"}}}
"}}}

" User_Command:"{{{
com! -nargs=0 UB :call <sid>UndoBrowse()
"}}}

" Restore:
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4
