" Examples for tinymode.vim
" File:         tinym_ex.vim
" Created:      2008 Apr 29
" Last Change:  2008 Aug 15
" Rev Days:     20
" Author:	Andy Wokula <anwoku@yahoo.de>
" Version:	0.5

" Usage:
"   :so %
" or load once from any place:
"   :call tinym_ex#require()

" Scriptenc: ... {{{
scriptenc latin1
let s:cpo_sav = &cpo
set cpo&vim
" character µ used }}}

" Look Here: Which modes to activate
" Custom Variables: "{{{
" which modes to activate
" you can reload tinym_ex.vim after changing this variable; disabled modes will
" be wiped out
if !exists("tinym_ex_modes")
    let tinym_ex_modes = ",cytab,winsize,less,"
else
    let tinym_ex_modes = substitute(tinym_ex_modes,'^,\?\|,\?$\|,\s*',',','g')
    " assure a leading and a trailing comma and remove white space after commas
endif

" for mode "cytab", also map keys to create, close and move tab pages:
if !exists("tinym_ex_cytab_edit")
    let tinym_ex_cytab_edit = 0
endif
"}}}

" skip for now:
" Functions: "{{{
func! tinym_ex#require()
    " intentionally empty
endfunc

" for mode wiping when sourcing this script: unmap a Normal mode key, but only
" if it is a tinymode enter map
func! s:nunmap(key, mode_as_cond)
    if maparg(a:key, "n") =~ '<SNR>\d\+_go("'. a:mode_as_cond. '",'
	exec "nunmap" a:key
    endif
    " pattern: a:mode should only contain letters
    " very much depends on tinymode#EnterMap()
endfunc

"" func! tinym_ex#SetVar(varname, value)
""     " set a variable local to tinym_ex.vim (not tinymode.vim)
""     let {a:varname} = a:value
"" endfunc

"}}}

" Look Here: Example Modes
" cytab:   gt       cycle tab pages {{{1
if tinym_ex_modes =~ ',cytab,'
    " Enter mode with "gt" or "gT", keys in the mode: "0", "t", "T", "$", type a
    " Normal mode command to leave the mode or wait 3 s.
    " Keys With Count: t, T
    call tinymode#ModeMsg("cytab", '-- Cycle tab pages -- 0/T/t/$', 1)
    call tinymode#EnterMap("cytab", "gt", "t")
    call tinymode#EnterMap("cytab", "gT", "T")
    call tinymode#Map("cytab", "0", "tabfirst")
    call tinymode#Map("cytab", "t", "norm! [N]gt")
    call tinymode#Map("cytab", "T", "norm! [N]gT")
    " :tablast beeps if there is only one tab page, huh?
    call tinymode#Map("cytab", "$", "sil! tablast")
    call tinymode#ModeArg("cytab", "owncount", 1)

    " Extras: tab creation and movement
    if tinym_ex_cytab_edit
	" Keys With Count: M
	call tinymode#ModeMsg("cytab", "Cycle tab pages 0/T/t/$, N/n/C/c:new/close, M/H/L:move", 1)
	call tinymode#ModeArg("cytab", "timeoutlen", 10000)
	call tinymode#Map("cytab", "n", "tabnew")
	call tinymode#Map("cytab", "N", "0tabnew")
	call tinymode#Map("cytab", "c", "tabclose")
	" close the tab page to the left:
	call tinymode#Map("cytab", "C", 'exec "sil! tabclose" tabpagenr()-1')
	" move the tab page left/right:
	call tinymode#Map("cytab", "H", 'exec "tabmove" max([tabpagenr()-2,0])')
	call tinymode#Map("cytab", "L", 'exec "tabmove" tabpagenr()')
	" move tab page before tab page [N] (default 1)
	call tinymode#Map("cytab", "M", 'exec "tabmove" max([[N]-1,0])')
    endif
else
    " wipe out this mode
    " sil! nunmap gt
    call s:nunmap("gt", "cytab")
    call s:nunmap("gT", "cytab")
    sil! unlet tinymode#modes.cytab
endif

" winsize: <C-W>+   change window size {{{1
if tinym_ex_modes =~ ',winsize,'
    call tinymode#EnterMap("winsize", "<C-W>>", ">")
    call tinymode#EnterMap("winsize", "<C-W><", "<")
    call tinymode#EnterMap("winsize", "<C-W>+", "+")
    call tinymode#EnterMap("winsize", "<C-W>-", "-")

    call tinymode#ModeMsg("winsize", "Change window size +/-/</>/t/b/w/W/_/|/=")
    call tinymode#ModeArg("winsize", "owncount", 1)
    call tinymode#ModeArg("winsize", "timeoutlen", "20000")

    call tinymode#Map("winsize", "+", "[N]wincmd +")
    call tinymode#Map("winsize", "-", "[N]wincmd -")
    " >/<: if no count is given, use the last count:
    call tinymode#Map("winsize", ">", 'call tinym_ex#WinsizeVert("[N]",">")')
    call tinymode#Map("winsize", "<", 'call tinym_ex#WinsizeVert("[N]","<")')
    call tinymode#Map("winsize", "t", "wincmd t")
    call tinymode#Map("winsize", "b", "wincmd b")
    call tinymode#Map("winsize", "w", "sil! [N]wincmd w")
    call tinymode#Map("winsize", "W", "sil! [N]wincmd W")
    call tinymode#Map("winsize", "_", "[N]wincmd _")
    call tinymode#Map("winsize", "<bar>", "[N]wincmd |")

    " call tinymode#Map("winsize", "=", "wincmd = | redraw")
    " support darkroom.vim:
    call tinymode#Map("winsize", "=", 'exec "normal \<C-W>=" | redraw')

    let s:winsize_vertcount = "5"

    func! tinym_ex#WinsizeVert(count, wincmd)
	if a:count != ""
	    let s:winsize_vertcount = a:count
	endif
	exec s:winsize_vertcount."wincmd" a:wincmd
    endfunc
else
    " wipe out this mode
    call s:nunmap("<C-W>>", "winsize")
    call s:nunmap("<C-W><", "winsize")
    call s:nunmap("<C-W>+", "winsize")
    call s:nunmap("<C-W>-", "winsize")
    sil! unlet tinymode#modes.winsize
    sil! unlet s:winsize_vertcount
    sil! delfunc tinym_ex#WinsizeVert
endif

" less:    \es      simulate less (sort of) {{{1
if tinym_ex_modes =~ ',less,'
    " vim_use
    " From:	    Timothy Madden <terminatorul gmail com>
    " Date:	    2008 Aug 06
    " Subject:  Can I add a new mode in vim for viewing files ?
    "   Is there a way to turn vim into a file viewer, and have it scroll text
    "   with h, k, j, l by one line/col,
    "   d and u by half a page, b, f, zH and zL by one page ?
    " Answer:   YES, see below
    " Notes:    Press q or Esc to exit less mode without starting a new action.
    "   After d or u with count, press 0 to set the count back to half window
    "   height.  h and l remember the last given count.  Less mode times out
    "   after 10 minutes.  Tries to hide the cursor, should work for GUI.
    call tinymode#EnterMap("less", "<Leader>es")

    call tinymode#ModeMsg("less", "Less mode j/k/h/l/0/d/u/b/f/gg/G/q", 1)
    " zh/zl: the count is remembered:
    call tinymode#Map("less", "h", 'call tinym_ex#Less_Move("[N]","zh","vert")')
    call tinymode#Map("less", "l", 'call tinym_ex#Less_Move("[N]","zl","vert")')
    call tinymode#Map("less", "k", "normal! [N]\<C-Y>")
    call tinymode#Map("less", "j", "normal! [N]\<C-E>")
    call tinymode#Map("less", "d", "normal! [N]\<C-D>")
    call tinymode#Map("less", "u", "normal! [N]\<C-U>")
    call tinymode#Map("less", "b", "normal! [N]\<C-B>")
    call tinymode#Map("less", "f", "normal! [N]\<C-F>")
    call tinymode#Map("less", "gg","normal! [N]gg")
    call tinymode#Map("less", "G", "normal! [N]G")
    call tinymode#Map("less", "q", "LeaveMode!")
    " "0" does two different things:
    call tinymode#Map("less", "0", "set scroll=0| normal! 0")
    call tinymode#ModeArg("less", "entercmd", "call tinym_ex#Less_Setup('enable')")
    call tinymode#ModeArg("less", "leavecmd", "call tinym_ex#Less_Setup('disable')")
    call tinymode#ModeArg("less", "owncount", 1)
    call tinymode#ModeArg("less", "timeoutlen", 600000)

    if hlID("LessCursor")==0
	" hi LessCursor guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
	hi clear LessCursor
    endif

    let s:less_counts = {"vert": 5}

    func! tinym_ex#Less_Setup(switch)
	if a:switch == 'enable'
	    if exists("s:less_savopt")
		return
	    endif
	    let s:less_savopt = [&wrap, &so, &sol, &ve, &cul, &cuc]
	    setlocal nowrap nocul nocuc
	    set scrolloff=0 nostartofline virtualedit=all
	    if exists("+guicursor")
		call add(s:less_savopt, &gcr)
		set guicursor=n:block-LessCursor-blinkon0
	    else
		call add(s:less_savopt, "")
	    endif
	elseif a:switch == 'disable'
	    let [&l:wrap, &so, &sol, &ve, &l:cul, &l:cuc, sav_gcr] = s:less_savopt
	    if exists("+guicursor")
		let &gcr = sav_gcr
	    endif
	    unlet s:less_savopt
	endif
    endfunc

    func! tinym_ex#Less_Move(count, ncmd, cid)
	if a:count != ""
	    let s:less_counts[a:cid] = a:count
	endif
	exec "normal!" s:less_counts[a:cid]. a:ncmd
    endfunc
else
    " wipe out this mode
    call s:nunmap("<Leader>es", "less")
    sil! unlet tinymode#modes.less
    sil! unlet s:less_counts
    sil! delfunc tinym_ex#Less_Setup
    sil! delfunc tinym_ex#Less_Move
endif
"}}}

" Modes not enabled per default:
" switchbuf: \      quick buf switch by number {{{1
" Usage: Type \27 (or 2\7 or 27\) to edit buffer 27.  Timeout is 500 ms for
" ambigious numbers.  <Esc> cancels, <Enter> or <Space> do accept (like any
" other key, but not executing).  Too big numbers edit the last buffer.
" Strange: :b {N} followed by :b does strange things - disable that
" just a note: LeaveMode exec'd twice: 999\<Enter>
if tinym_ex_modes =~ ',switchbuf,'
    call tinymode#EnterMap("switchbuf", "<Leader>")

    call tinymode#ModeArg("switchbuf", "entercmd",
	\ "let g:sbcount = ''| call tinym_ex#SwitchBuf('[N]',1)")
    call tinymode#ModeArg("switchbuf", "leavecmd",
	\ "exec 'b'[g:sbcount=='':] g:sbcount| unlet g:sbcount")
    call tinymode#ModeArg("switchbuf", "timeoutlen", 500)
    call tinymode#ModeArg("switchbuf", "timeoutonce", 1)
    call tinymode#ModeArg("switchbuf", "noclear", 1)

    call tinymode#Map("switchbuf", "0", "call tinym_ex#SwitchBuf(0)")
    call tinymode#Map("switchbuf", "1", "call tinym_ex#SwitchBuf(1)")
    call tinymode#Map("switchbuf", "2", "call tinym_ex#SwitchBuf(2)")
    call tinymode#Map("switchbuf", "3", "call tinym_ex#SwitchBuf(3)")
    call tinymode#Map("switchbuf", "4", "call tinym_ex#SwitchBuf(4)")
    call tinymode#Map("switchbuf", "5", "call tinym_ex#SwitchBuf(5)")
    call tinymode#Map("switchbuf", "6", "call tinym_ex#SwitchBuf(6)")
    call tinymode#Map("switchbuf", "7", "call tinym_ex#SwitchBuf(7)")
    call tinymode#Map("switchbuf", "8", "call tinym_ex#SwitchBuf(8)")
    call tinymode#Map("switchbuf", "9", "call tinym_ex#SwitchBuf(9)")
    call tinymode#Map("switchbuf", "<Enter>", "LeaveMode!")
    call tinymode#Map("switchbuf", "<Space>", "LeaveMode!")
    call tinymode#Map("switchbuf", "<Esc>", "let g:sbcount=''|LeaveMode!")

    func! tinym_ex#SwitchBuf(bufnr, ...)
	let g:sbcount .= a:bufnr
	if g:sbcount."0" > bufnr("$")
	    if g:sbcount > bufnr("$")
		let g:sbcount = bufnr("$")
	    endif
	    echo ":b" g:sbcount
	    LeaveMode!
	elseif a:0==0
	    echo ":b" g:sbcount
	endif
    endfunc
else
    call s:nunmap("<Leader>", "switchbuf")
    sil! unlet tinymode#modes.switchbuf
    sil! delfunc tinym_ex#SwitchBuf
endif

" cucl:    \c       cycle 'cursorline' and 'cursorcolumn' {{{1
if tinym_ex_modes =~ ',cucl,'
    " enter mode with <Leader>c or <Leader>C
    call tinymode#EnterMap("cucl", "<Leader>c", "c")
    call tinymode#EnterMap("cucl", "<Leader>C", "C")
    call tinymode#ModeMsg("cucl", "Toggle 'cuc'+'cul' [c/C/o(f)f]")
    call tinymode#Map("cucl", "c", "let [&l:cuc,&l:cul] = [&cul,!&cuc]")
    call tinymode#Map("cucl", "C", "let [&l:cuc,&l:cul] = [!&cul,&cuc]")
    call tinymode#Map("cucl", "f", "setl nocuc nocul")
else
    " wipe out this mode
    call s:nunmap("<Leader>c", "cucl")
    call s:nunmap("<Leader>C", "cucl")
    sil! unlet tinymode#modes.cucl
endif

" debug:   \d       toggle 'debug' values {{{1
if tinym_ex_modes =~ ',debug,'
    call tinymode#EnterMap("debug", "<Leader>d", "µ")
    " no message
    call tinymode#Map("debug", "b", "call tinym_ex#ToggleDebug('beep')")
    call tinymode#Map("debug", "m", "call tinym_ex#ToggleDebug('msg')")
    call tinymode#Map("debug", "t", "call tinym_ex#ToggleDebug('throw')")
    call tinymode#Map("debug", "µ", "call tinym_ex#ToggleDebug('')")

    func! tinym_ex#ToggleDebug(value)
	" 'debug' is buggy, debug+=value doesn't work if not empty
	if a:value != ""
	    if &debug == ""
		let &debug = a:value
	    elseif &debug =~ a:value
		let pat =  a:value.',\|,'.a:value.'\|'.a:value
		let &debug = substitute(&debug, pat, '', '')
	    else
		let &debug .= ",". a:value
	    endif
	endif
	let str = printf("  debug=%.14s  (b)eep/(m)sg/(t)hrow ", &debug. repeat(" ", 14))
	" echo str
	call tinymode#ModeMsg("debug", str)
    endfunc

    " Note:
    "   :call s:ToggleDebug('beep')
    " doesn't work, because the call happens in the context of tinymode.vim.
    " Sorry we need to determine the <SNR> of THIS script.  OR with luck, THIS
    " is an autoload script.  OR ... simply call a global function.
else
    " wipe out this mode
    call s:nunmap("<Leader>d", "debug")
    sil! unlet tinymode#modes.debug
    sil! delfunc tinym_ex#ToggleDebug
endif

" Cleanup Modeline: {{{1
let &cpo = s:cpo_sav
unlet s:cpo_sav
" vim:set isk+=# ts=8 sts=4 sw=4 noet tw=80 fdm=marker:
