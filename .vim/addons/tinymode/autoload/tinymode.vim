" Vim autoload plugin - provide "tiny modes" for Normal mode
" File:         tinymode.vim
" Vimscript:	2223
" Created:      2008 Apr 29
" Last Change:  2008 Aug 15
" Rev Days:     28
" Author:	Andy Wokula <anwoku@yahoo.de>
" Version:	0.5

" Testing: "{{{
" - ACTERR continue after errors from an action
"}}}

" Init: "{{{
let s:tm_sav_cpo = &cpo
set cpo&vim

let tinymode#loaded = 1

if !exists("g:tinymode#modes")
    let g:tinymode#modes = {}
endif
if !exists("g:tinymode#defaults")
    let g:tinymode#defaults = {}
endif
call extend(g:tinymode#defaults, {
		\   "owncount": 0, "countpat": '\C\[N]'
		\,  "entercmd": "", "leavecmd": ""
		\,  "timeoutlen": 3000, "timeoutonce": 0
		\,  "noclear": 0 }, "keep")

let s:tm_quitnormal = 1

nn <sid>go :<c-u>call tinymode#enter
nn <sid>do :<c-u>call <sid>action
nn <sid>atc :<c-u>call <sid>addtocount
" feed count to Normal mode
nmap <expr> <sid>fdc <sid>count()
nn <script><silent> <sid>clean :call<sid>clean()<cr><sid>fdc
nn <script><silent> <sid>delay :call<sid>dotimeout()<cr><sid>end
nn <script><silent> <sid>_<sid>clean <sid>clean

ino <script> <sid>ta <C-O><sid>ta
ino <sid>fdc x<BS>
ino <script> <sid>end <C-O><sid>end

" DEBUG
" nn <sid>_ <sid>_
" let mp = maparg("<sid>_")

"}}}

func! tinymode#enter(mode, startkey) "{{{
    if s:tm_quitnormal
	let s:tm_sav_sc = &sc
	let s:tm_sav_lz = &lz
	let s:tm_sav_cpo = &cpo
	let s:tm_sav_tm = &tm
    endif
    let s:tm_quitnormal = 0
    call s:setoptions()

    " type ahead
    nmap <sid>ta <sid>_
    nmap <sid>_ <sid>delay
    nmap <sid>_<esc> <sid>clean
    nmap <sid>end <sid>ta

    let s:tm_goterror = 0
    let s:tm_curmode = g:tinymode#modes[a:mode]
    let s:tm_count = v:count>0 ? v:count : ""
    let s:tm_owncount = has_key(s:tm_curmode, "owncount")
    if s:tm_owncount
	call s:docountmaps()
    endif
    if has_key(s:tm_curmode, "countpat")
	let s:tm_countpat = s:tm_curmode.countpat
    else
	let s:tm_countpat = g:tinymode#defaults.countpat
    endif

    call s:domodemaps()

    if has_key(s:tm_curmode, "timeoutlen")
	let s:tm_modetmlen = s:tm_curmode.timeoutlen
    else
	let s:tm_modetmlen = g:tinymode#defaults.timeoutlen
    endif
    if has_key(s:tm_curmode, "entercmd")
	try
	    exec substitute(s:tm_curmode.entercmd, s:tm_countpat, s:tm_count, 'g')
	catch
	    call s:showexception()
	    call <sid>clean()
	    return
	endtry
    endif
    call <sid>action(a:startkey)
endfunc "}}}
func! <sid>action(key) "{{{
    let s:tm_tmcount = 2
    let s:tm_goterror = 0	" ACTERR added
    let cmd = get(s:tm_curmode.map, a:key, "")
    try
	exec substitute(cmd, s:tm_countpat, s:tm_count, 'g')
    catch
	call s:showexception()
	" call <sid>clean()	" ACTERR commented out
	" return		" ACTERR commented out
    endtry
    " OPTRESTORE
    let &timeoutlen = s:tm_modetmlen
    if s:tm_owncount
	if has_key(s:tm_curmode.map, "0")
	    nn <script><silent> <sid>_0 <sid>do("0")<cr><sid>ta
	else
	    sil! unmap <sid>_0
	endif
    endif
    let s:tm_count = ""
    if has_key(s:tm_curmode, "redraw")
	try
	    redraw
	catch
	    call s:showexception()
	    call <sid>clean()
	    return
	endtry
    endif
    call s:showmodemsg()
endfunc "}}}
func! <sid>addtocount(digit) "{{{
    let s:tm_count .= a:digit
    if strlen(s:tm_count) == 1
	nn <script><silent> <sid>_0 <sid>atc("0")<cr><sid>ta
    endif
    call s:showmodemsg()
endfunc "}}}
func! <sid>count() "{{{
    return s:tm_count
endfunc "}}}
func! <sid>dotimeout() "{{{
    let s:tm_tmcount -= 1
    if s:tm_tmcount == 1
	let &timeoutlen = s:tm_sav_tm
	if has_key(s:tm_curmode, "timeoutonce")
	    nn <script> <sid>end <sid>clean
	else
	    call s:showmodemsg()
	endif
    elseif s:tm_tmcount == 0
	nn <script> <sid>end <sid>clean
    endif
endfunc "}}}
func! s:showmodemsg() "{{{
    if !(has_key(s:tm_curmode, "msg") && !s:tm_goterror)
	return
    endif
    if s:tm_tmcount > 1
	echohl ModeMsg
    else
	echohl none
    endif
    if s:tm_count == ""
	echo printf("%.".(&co-12)."s", s:tm_curmode.msg)
    else
	echo printf("%.".(&co-12)."s", s:tm_curmode.msg. " ". s:tm_count)
    endif
    echohl none
endfunc "}}}
func! <sid>clean() "{{{
    if s:tm_quitnormal
	return
    endif
    if !s:tm_goterror && has_key(s:tm_curmode, "leavecmd")
	try
	    exec substitute(s:tm_curmode.leavecmd, s:tm_countpat, s:tm_count, 'g')
	catch
	    call s:showexception()
	endtry
    endif
    call tinymode#MapClear()
    let &showcmd = s:tm_sav_sc
    let &lazyredraw = s:tm_sav_lz
    let &cpoptions = s:tm_sav_cpo
    let &timeoutlen = s:tm_sav_tm
    let s:tm_quitnormal = 1
    if !s:tm_goterror && !has_key(s:tm_curmode, "noclear")
	exec "norm! :\<c-u>"
    endif
endfunc "}}}
func! s:showexception() "{{{
    let s:tm_goterror = 1
    echohl ErrorMsg
    if v:exception =~ '^Vim'
	echomsg matchstr(v:exception, ':\zs.*')
    else
	echomsg v:exception
    endif
    echohl none
    " sleep 2
endfunc "}}}
func! s:setoptions() "{{{
    " moved here from tinymode#enter(); you can add :TimoRestore to commands
    " in tinymode#Map(), to recover when a nasty command changes these
    " options:
    set noshowcmd
    set nolazyredraw
    set cpo-=K cpo-=<
    " be sure 'timeoutlen' is set afterwards, there: OPTRESTORE
endfunc "}}}
func! s:domodemaps() "{{{
    for key in keys(s:tm_curmode.map)
	exec "nn <script><silent> <sid>_".key '<sid>do("'.
		    \ substitute(key,"<","<lt>","g").'")<cr><sid>ta'
    endfor
endfunc "}}}
func! s:docountmaps() "{{{
    for digit in range(1, 9)
	exec "nn <script><silent> <sid>_".digit '<sid>atc("'.digit.'")<cr><sid>ta'
    endfor
endfunc "}}}
func! s:leavemode(bang, whattofeed) "{{{
    if a:bang
	nmap <sid>ta <sid>clean
    elseif !s:tm_quitnormal
	call feedkeys(a:whattofeed)
    else
	echomsg "LeaveMode: Not inside a mode"
    endif
endfunc "}}}

" Interface:
" {mode} is an arbitrary, unique name to identify the mode.
" The following functions can be called in any order!

" Map a Normal mode {key} to enter the new {mode}.  {startkey} can simulate
" an initial keypress in the new mode.
func! tinymode#EnterMap(mode, key, ...) "{{{
    " a:1 -- startkey
    let startkey = a:0>=1 ? escape(a:1, '\"') : ""
    let mode = escape(a:mode, '\"')
    exec "nn <special><script><silent>" a:key '<sid>go("'.mode.'","'.
		\ substitute(startkey,"<","<lt>","g").'")<cr><sid>ta'

    if startkey == ""
	if !has_key(g:tinymode#modes, a:mode)
	    let g:tinymode#modes[a:mode] = {"map": {}}
	endif
    else
	try
	    call extend(g:tinymode#modes[a:mode].map, {startkey : ""}, "keep")
	catch
	    if !has_key(g:tinymode#modes, a:mode)
		let g:tinymode#modes[a:mode] = {"map": {startkey : ""}}
	    else
		let g:tinymode#modes[a:mode].map = {startkey : ""}
	    endif
	endtry
    endif
endfunc "}}}

" Define a permanent {message} for the command-line, useful to know which
" {mode} you are in; if your commands overwrite the message, try setting
" {redraw} to 1
func! tinymode#ModeMsg(mode, message, ...) "{{{
    " a:1 -- redraw (1 or default 0)
    if a:message == ""
	sil! unlet g:tinymode#modes[a:mode].msg
	sil! unlet g:tinymode#modes[a:mode].redraw
	return
    endif
    let redraw = a:0>=1 ? a:1 : 0
    try
	let g:tinymode#modes[a:mode].msg = a:message
    catch
	let g:tinymode#modes[a:mode] = {"msg": a:message}
    endtry
    if redraw
	let g:tinymode#modes[a:mode].redraw = 1
    endif
endfunc "}}}

" Map a {key} to an Ex-{command} within the new {mode}.  You can use
" ":normal" to execute Normal mode commands from the mapping and to control
" remapping of keys.  Place "[N]" in the command for the count.
func! tinymode#Map(mode, key, command) "{{{
    try
	let g:tinymode#modes[a:mode].map[a:key] = a:command
    catch
	if !has_key(g:tinymode#modes, a:mode)
	    let g:tinymode#modes[a:mode] = {"map": {a:key : a:command}}
	else
	    let g:tinymode#modes[a:mode].map = {a:key : a:command}
	endif
    endtry
endfunc "}}}
func! tinymode#Unmap(mode, key) "{{{
    try
	unlet g:tinymode#modes[a:mode].map[a:key]
    catch
	echohl ErrorMsg
	echomsg 'Tinymode: no such mapping'
	echohl none
    endtry
endfunc "}}}

" Set a {mode}-local {option} to a given {value}.  Every {option} is also
" boolean: it can exist or not exist (to be changed later).
" Description: {option}: {value}
" "owncount": if set, typed digits are processed within the mode
" "countpat": pattern for replacing the count placeholder in a command
" (default '\C\[N]')
" "entercmd": Ex-command to execute when entering the mode, before
" simulating any startkey (default "")
" "leavecmd": command to execute when leaving the mode (default "")
" "timeoutlen": 'timeoutlen' for first (main) timeout step
" "timeoutonce": if set, omit the second timeout step (with user 'timeoutlen')
" "noclear": if set, don't clear the cmdline on leave
func! tinymode#ModeArg(mode, option, ...) "{{{
    " a:1 -- {value} (default depends on option)
    if !has_key(g:tinymode#defaults, a:option)
	echomsg "tinymode: not a valid modearg: '".a:option."'"
	return
    endif
    if a:0 == 0
	sil! unlet g:tinymode#modes[a:mode][a:option]
    else
	try
	    let g:tinymode#modes[a:mode][a:option] = a:1
	catch
	    let g:tinymode#modes[a:mode] = {a:option : a:1}
	endtry
    endif
endfunc "}}}

" like :mapclear for {mode}
func! tinymode#MapClear(...) abort "{{{
    if a:0 >= 1
	let mode = a:1
	let db = g:tinymode#modes[mode]
    else
	let db = s:tm_curmode
    endif
    if has_key(db, "owncount")
	for digit in range(0, 9)
	    exec "sil! unmap <sid>_". digit
	endfor
    endif
    for key in keys(db.map)
	exec "sil! unmap <sid>_". key
    endfor
endfunc "}}}

" Commands: {{{1
com! -bar -bang LeaveMode   call s:leavemode(<bang>0,"<SID>clean")
com! -bar TimoRestore	    if !s:tm_quitnormal<Bar> call s:setoptions()<Bar> endif

" DEBUG
" com! -nargs=* TimoLocal <args>

" Cleanup Modeline: {{{1
let &cpo = s:tm_sav_cpo
unlet s:tm_sav_cpo
" vim:set fdm=marker ts=8 sts=4 sw=4 noet:
