" histwin.vim - Vim global plugin for browsing the undo tree
" -------------------------------------------------------------
" Last Change: 2010, Jan 21
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Version:     0.8
" Copyright:   (c) 2009 by Christian Brabandt
"              The VIM LICENSE applies to histwin.vim 
"              (see |copyright|) except use "histwin.vim" 
"              instead of "Vim".
"              No warranty, express or implied.
"    *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: - write documentation
"       - don't use matchadd for syntax highlighting but use
"         appropriate syntax highlighting rules

" Init:
let s:cpo= &cpo
set cpo&vim

" Show help banner?
" per default enabled, you can change it,
" if you set g:undobrowse_help to 0 e.g.
" put in your .vimrc
" :let g:undo_tree_help=0
let s:undo_help=((exists("s:undo_help") ? s:undo_help : 1) )"}}}

" Functions:
fun! s:Init()
	if exists("g:undo_tree_help")
	   let s:undo_help=g:undo_tree_help
	endif
	if !exists("s:undo_winname")
		let s:undo_winname='Undo_Tree'
	endif
	" speed, with which the replay will be played
	" (duration between each change in milliseconds)
	" set :let g:undo_tree_speed=250 in your .vimrc to override
	let s:undo_tree_speed=(exists('g:undo_tree_speed') ? g:undo_tree_speed : 100)
	let s:undo_tree_wdth=(exists('g:undo_tree_wdth') ? g:undo_tree_wdth : 30)
	if bufname('') != s:undo_winname
		let s:orig_buffer = bufnr('')
	endif
	" Make sure we are in the right buffer
	" and this window still exists
	if bufwinnr(s:orig_buffer) == -1
		wincmd p
		let s:orig_buffer=bufnr('')
	endif
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	" Move to the buffer, we are monitoring
	if !exists("b:undo_tagdict")
		let b:undo_tagdict={}
	endif
	if !exists("b:undo_list")
	    let b:undo_list=[]
	endif
endfun 

fun! s:ReturnHistList(winnr)
	let histlist=[]
	redir => a
	sil :undol
	redir end
	" First item contains the header
	let templist=split(a, '\n')[1:]
	" include the starting point as the first change.
	" unfortunately, there does not seem to exist an 
	" easy way to obtain the state of the first change,
	" so we will be inserting a dummy entry and need to
	" check later, if this is called.
	if exists("b:undo_list") && !empty(get(b:undo_list,0,''))
		call add(histlist, b:undo_list[0])
	else
		call add(histlist, {'change': 0, 'number': 0, 'time': '00:00:00'})
	endif
	if empty(get(b:undo_tagdict, 0,''))
		let b:undo_tagdict[0]='Start Editing'
	endif
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
endfun 

fun! s:HistWin()
	let undo_buf=bufwinnr('^'.s:undo_winname.'$')
	if undo_buf != -1
		exe undo_buf . 'wincmd w'
		if winwidth(0) != s:undo_tree_wdth
			exe "vert res " . s:undo_tree_wdth
		endif
	else
	execute s:undo_tree_wdth . "vsp " . s:undo_winname
	setl noswapfile buftype=nowrite bufhidden=delete foldcolumn=0 nobuflisted nospell
	let undo_buf=bufwinnr("")
	endif
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	return undo_buf
endfun 

fun! s:PrintUndoTree(winnr)
	let bufname  = (empty(bufname(s:orig_buffer)) ? '[No Name]' : fnamemodify(bufname(s:orig_buffer),':t'))
	let changenr = changenr()
	exe a:winnr . 'wincmd w'
	let save_cursor=getpos('.')
	setl modifiable
	" silent because :%d outputs this message:
	" --No lines in buffer--
	silent %d _
	let histlist = getbufvar(s:orig_buffer, 'undo_list')
	let tagdict  = getbufvar(s:orig_buffer, 'undo_tagdict')
	call setline(1,'Undo-Tree: '.bufname)
	put =repeat('=', strlen(getline(1)))
	put =''
	call s:PrintHelp(s:undo_help)
	call append('$', printf("%-*s %-9s %s", strlen(len(histlist)), "Nr", "  Time", "Tag"))
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
	call s:MapKeys()
	call s:HilightLines(s:GetCurrentState(changenr,histlist)+1)
	setl nomodifiable
	call setpos('.', save_cursor)
endfun 

fun! s:HilightLines(changenr)
	" check for availability of matchadd()/clearmatches()
	if !exists("*matchadd") || !exists("*clearmatches")
		return
	endif
	" only highlight, if those groups are declared.
    call clearmatches()
	if hlexists('Title')		|	call matchadd('Title', '^\%1lUndo-Tree: \zs.*$')	|	endif
	if hlexists("Comment")		| 	call matchadd('Comment', '^".*$')					|	endif
	if hlexists("Identifier")	| 	call matchadd('Identifier', '^\d\+\ze)')			|	endif
	if hlexists("Special")		| 	call matchadd('Special', '/\zs.*\ze/$')				|	endif
	if hlexists("Underlined")	| 	call matchadd('Underlined', '^\d\+)\s\+\zs\S\+')	|	endif
	if hlexists("Ignore")		
		call matchadd('Ignore', '/$')
		call matchadd('Ignore', '/\ze.*/$')					
	endif
	if a:changenr 
		if hlexists("PmenuSel") | 	call matchadd('PmenuSel', '^0*'.a:changenr.')[^/]*')|	endif
	endif
endfun 

fun! s:PrintHelp(...)
	let mess=['" actv. keys in this window']
	call add(mess, '" I toggles help screen')
	if a:1
		call add(mess, "\" <Enter> goto undo branch")
		call add(mess, "\" <C-L>\t  Update view")
		call add(mess, "\" T\t  Tag sel. branch")
		call add(mess, "\" D\t  Diff sel. branch")
		call add(mess, "\" R\t  Replay sel. branch")
		call add(mess, "\" Q\t  Quit window")
		call add(mess, '"')
		call add(mess, "\" Undo-Tree, v" . string(g:loaded_undo_browse))
	endif
	call add(mess, '')
	call append('$', mess)
endfun 

fun! s:DiffUndoBranch(change)
	let prevchangenr=<sid>UndoBranch(a:change)
	let buffer=getline(1,'$')
	exe ':u ' . prevchangenr
	exe ':botright vsp '.tempname()
	call setline(1, bufname(s:orig_buffer) . ' undo-branch: ' . a:change)
	call append('$',buffer)
	silent w!
	diffthis
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	diffthis
endfun 

fun! s:GetCurrentState(changenr,histlist)
	let i=0
	for item in a:histlist
	    if item['change'] == a:changenr
		   return i
		endif
		let i+=1
	endfor
	return -1
endfun!

fun! s:ReplayUndoBranch(change)
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	let end=b:undo_list[a:change-1]['number']
	exe ':u ' . b:undo_list[a:change-1]['change']
	exe 'normal ' . end . 'u' 
	redraw
	let start=1
	while start <= end
	red
	redraw
	exe ':sleep ' . s:undo_tree_speed . 'm'
	let start+=1
	endw
endfun 

fun! s:ReturnBranch()
	return matchstr(getline('.'), '^\d\+\ze')+0
endfun 

fun! s:ToggleHelpScreen()
	let s:undo_help=!s:undo_help
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	call s:PrintUndoTree(s:HistWin())
endfun 

fun! s:UndoBranchTag(change)
	let tagdict=getbufvar(s:orig_buffer, 'undo_tagdict')
	call inputsave()
	let tag=input("Tagname " . a:change . ": ", get(tagdict, a:change-1, ''))
	call inputrestore()
	let tagdict[a:change-1] = tag
	call setbufvar('#', 'undo_tagdict', tagdict)
	call s:PrintUndoTree(s:HistWin())
endfun 

fun! s:UndoBranch(change)
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	" Save cursor pos
	let cpos = getpos('.')
	let cmd=''
	let cur_changenr=changenr()
	let len = len(b:undo_list)
	" if len==1, then there is no
	" undo branch available, which means
	" we can't undo anyway
	if a:change <= len && len >1
		if a:change<=1
		   " Jump back to initial state
			"let cmd=':earlier 9999999'
			let change = b:undo_list[a:change]['change']
			let steps  = b:undo_list[a:change]['number']
			exe ':u ' . change 
			exe ':norm' . steps . 'u'
			" probably not needed
			let b:undo_list[a:change-1]['change']=changenr()
		else
			exe ':u '.b:undo_list[a:change-1]['change']
		endif
	endif
	" this might have changed, so we return to the old cursor
	" position. This could still be wrong, so
	" So this is our best effort approach.
	call setpos('.', cpos)
	return cur_changenr
endfun 

fun! s:MapKeys()
	noremap <script> <buffer> I     :<C-U>silent :call <sid>ToggleHelpScreen()<CR>
	noremap <script> <buffer> <CR>  :<C-U>silent :call <sid>UndoBranch(<sid>ReturnBranch())<CR>:call histwin#UndoBrowse()<CR>
	noremap <script> <buffer> T     :call <sid>UndoBranchTag(<sid>ReturnBranch())<CR>
	noremap <script> <buffer> D     :<C-U>silent :call <sid>DiffUndoBranch(<sid>ReturnBranch())<CR>
	noremap <script> <buffer> <C-L> :<C-U>silent :call histwin#UndoBrowse()<CR>
	noremap <script> <buffer> R     :<C-U>silent :call <sid>ReplayUndoBranch(<sid>ReturnBranch())<CR>
	"noremap <script> <buffer> B     :call <sid>CreateNewBranch()<CR>
	noremap <script> <buffer> Q     :<C-U>q<CR>
endfun 

fun! histwin#UndoBrowse()
	if &ul != -1
		call s:Init()
		let b:undo_win  = s:HistWin()
		let b:undo_list = s:ReturnHistList(bufwinnr(s:orig_buffer))
		call s:PrintUndoTree(b:undo_win)
	else
		echoerr "Undo has been disabled. Check your undolevel setting!"
	endif
endfun 

" Restore:
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\" spell spelllang=en fdm=syntax
