" Vim plugin -- repeat motions for which a count was given
" General: {{{1
" File:         repmo.vim
" Created:      2008 Jan 27
" Last Change:  2014 Jun 05
" Rev Days:     9
" Author:	Andy Wokula <anwoku@yahoo.de>
" Version:	0.5.3

" Question: BML schrieb: Is there a way/command to repeat the last movement,
"   like ; and , repeat the last f command? It would be nice to be able to
"   select the 'scrolling' speed by typing 5j or 8j, and then simply hold
"   down a key and what the text scroll by at your given speed. Ben
" Answer: No there isn't, but an exception is  :h 'scroll
"   Or take repmo.vim as an answer.  It overloads the keys ";" and "," to
"   repeat motions.

" Usage By Example:
"   Type "5j" and then ";" to repeat "5j" (after  :RepmoMap j k ).
"   Type "hjkl" and then ";", it still repeats "5j".
"   Type "," to do "5k" (go in reverse direction).
"   Type "4k" and then ";" to repeat "4k" (after  :RepmoMap k j ).
"
"   The following motions (and scroll commands) are mapped per default:
"	j,k, h,l, Ctrl-E,Ctrl-Y, zh,zl
"
" Compatibility:
" - Visual mode
" - "f{char}" followed by ";,"
" - Operator pending mode with ";" and ","

" Commands:
"   :RepmoMap {motion}|{reverse-motion} ... [<unique>] ...
"
"	Map {motion} to be repeatable with ";".  Use {reverse-motion} for
"	",".  Key notation is like in mappings.
"	If one of the arguments is <unique>, all key pairs right from it are
"	mapped with <unique> modifier (:h map-<unique>).

" Options:		    type	default	    when checked
"   g:repmo_key		    (string)	";"	    frequently, e.g. when
"   g:repmo_revkey	    (string)	","	      \ doing "5j"
"   g:repmo_mapmotions	    (bool)	1	    when sourced
"
" see Customization for details

" Installation:
"   it's a plugin, simply :source it (e.g. :so %)

" Hints:
" - there is little error checking, don't do  :let repmo_key = " " or "|"
"   etc.
" - to unmap "f", "F", "t", "T", ";" and "," at once, simply type "ff" (for
"   example); the next "5j" maps them again
" - to avoid mapping "f", "F", "t" and "T" at all, use other keys than ";"
"   and "," for repeating
" - Debugging:  :debug normal 5j  doesn't work, use  5:<C-U>debug normal j
"   instead; but  5:<C-U>normal jjj  does  5j5j5j
" - when changing g:repmo_key, g:repmo_revkey during session, the old keys
"   will not be unmapped automatically

" TODO:
" - more\test\C130.vim
" ? preserve remappings by user, e.g. :map j gj
"   currently these mappings are replaced without warning
" ? [count]{g:repmo_key} -- multiply the counts?
" - protect more alien :omaps (yankring!)
" + make ";" and "," again work with "f{char}", "F{char}", ...
" + v0.2 don't touch user's mappings for f/F/t/T
" + v0.2 check for empty g:repmo_key
" + check key notation: '\|' is ok, '|' not ok
"   no check added: we cannot check for everything
" + Bug: i_<C-O>l inserts rest of l-mapping in the text; for l and h
"   VimBuddy doesn't rotate its nose ... ah, statusline is updated twice
"   ! v0.3 use  :normal {motion}  within the function
" v0.5
" + :RepmoMap, new argument syntax
" + work in Vi-mode with <special>
" + added :sil! before  unmap ;  in case user unmapped ";" by hand
" + :normal didn't work with <Space> (i.e. " ")
" + let f/F/t/T accept a count when unmapping
" v0.5.1
" + make "v5j" work again after vim7.3.100 (:normal resets the count)
"   (fix by Joseph McCullough)
" v0.5.2
" ? made it work with yankstack 1.0.5

" }}}

" Script Init Folklore: {{{1
if exists("loaded_repmo")
    finish
endif
let loaded_repmo = 1

if v:version < 700 || &cp
    echo "Repmo: you need at least Vim 7 and 'nocp' set"
    finish
endif

let s:sav_cpo = &cpo
set cpo&vim
" " doesn't help, we need absent cpo-< all the time
" :h map-<special>

" Customization: {{{1

" keys used to repeat motions:
if !exists("g:repmo_key")
    " " key notation is like in mappings:
    " let g:repmo_key = "<Space>"
    " let g:repmo_revkey = "<BS>"
    let g:repmo_key = ";"
    let g:repmo_revkey = ","
endif

" motions to map per default
if !exists("g:repmo_mapmotions")
    let g:repmo_mapmotions = "j|k h|l <C-E>|<C-Y> zh|zl"
    " use "<bar>" to map "|"
endif

" Functions: {{{1

" Internal Variables: {{{
let s:lastkey = ""
let s:lastrevkey = ""
 "}}}

" Internal Mappings: "{{{
nn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(0,
vn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(1,

nn <silent> <sid>lastkey :<c-u>call<sid>MapRepMo(0)<cr>
vn <silent> <sid>lastkey :<c-u>call<sid>MapRepMo(1)<cr>

no <expr> <sid>cnt<Space> <sid>Count("get")
" straight (v:count>0 ? v:count : "") doesn't yet work with gVim7.1.315

let s:SNR = matchstr(maparg("<sid>lastkey", "n"), '<SNR>\d\+_')
 "}}}

func! RepmoMap(key, revkey, ...) abort "{{{
    " Args: {motion} {rev-motion}
    " map the {motion} key; {motion}+{rev-motion} on RHS
    let unique = a:0>=1 && a:1 ? "<unique>" : ""
    let lhs = printf("<special><script><silent>%s %s", unique, a:key)
    let rhs = "<sid>repmo('". substitute(a:key."','".a:revkey,"<","<lt>","g"). "')<cr>"
    if maparg(a:key, "o") == ""
	" makes the output of :map look better
	exec "noremap" lhs rhs
	exec "ounmap <special>" a:key
	exec "sunmap <special>" a:key
    else
	exec "nnoremap" lhs rhs
	exec "xnoremap" lhs rhs
    endif
    " omit :omap and :smap, protect alien :omaps (but not :smaps)
endfunc "}}}

func! <sid>MapRepeatMotion(vmode, key, revkey) "{{{
    " map ";" and ","
    " remap the motion a:key to something simpler than this function
    let cnt = v:count
    if a:vmode
	normal! gv
    endif
    let rawkey = eval('"'.escape(a:key, '\<"').'"')
    let whitecnt = (rawkey=~'^\s$' ? "1" : "")
    exec "normal!" (cnt >= 1 ? cnt : whitecnt). rawkey

    if s:lastkey != "" && s:lastkey != a:key
	" restore "full" mapping
	call RepmoMap(s:lastkey, s:lastrevkey)
    endif

    if cnt > 0
	" map ";" and ","
	let hasrepmo = 0
	if exists("g:repmo_key") && g:repmo_key != ''
	    exec "noremap <special>" g:repmo_key cnt.a:key
	    exec "sunmap <special>" g:repmo_key
	    let hasrepmo = 1
	endif
	if exists("g:repmo_revkey") && g:repmo_revkey != ''
	    exec "noremap <special>" g:repmo_revkey cnt.a:revkey
	    exec "sunmap <special>" g:repmo_revkey
	    let hasrepmo = 1
	endif
	if hasrepmo
	    call s:TransRepeatMaps()
	endif
    endif

    " map to leightweight func
    exec "nmap <special>" a:key "<sid>lastkey"
    exec "xmap <special>" a:key "<sid>lastkey"

    let s:lastkey = a:key
    let s:lastkeynorm = whitecnt. rawkey
    let s:lastrevkey = a:revkey

endfunc "}}}
func! <sid>MapRepMo(vmode) "{{{
    " lightweight version of <sid>MapRepeatMotion()
    if v:count==0
	if a:vmode
	    normal! gv
	endif
	exec "normal!" s:lastkeynorm
	return
    endif
    call <sid>MapRepeatMotion(a:vmode, s:lastkey, s:lastrevkey)
endfunc "}}}
func! <sid>Count(...) "{{{
    " count for zap motions when restoring
    if a:0 == 0
	let s:count = v:count>=1 ? v:count : ""
    else
	return s:count
    endif
endfunc "}}}

func! s:TransRepeatMaps() "{{{
    " trans is for transparent
    " check if repeating keys (e.g. ";" and ",") are overloaded, remap the
    " original commands (here: "f", "F", "t", "T")
    let cmdtype = ""
    let repmounmap = ""
    if g:repmo_key == ';' || g:repmo_revkey == ';'
	let repmounmap .= "<bar>sil! unmap ;"
	let cmdtype = "zap"
    endif
    if g:repmo_key == ',' || g:repmo_revkey == ','
	let repmounmap .= "<bar>sil! unmap ,"
	let cmdtype = "zap"
    endif
    if cmdtype == "zap"
	let cmdunmap = ""
	for zapcmd in ["f", "F", "t", "T"]
	    if !(maparg(zapcmd, "nx") == "" || maparg(zapcmd, "nx") =~ s:SNR)
		continue
	    endif
	    exec "nn <special><script><silent>" zapcmd ":<c-u><sid>cmdunmap<cr><sid>cnt" zapcmd
	    exec "xn <special><script><silent>" zapcmd ":<c-u><sid>cmdunmap<bar>norm!gv<cr><sid>cnt" zapcmd
	    let cmdunmap .= "<bar>sil! nunmap ". zapcmd. "<bar>sil! xunmap ". zapcmd
	endfor
	exec "cno <special><sid>cmdunmap call <sid>Count()". repmounmap. cmdunmap
    endif
endfunc "}}}

func! s:CreateMappings(pairs) "{{{
    if empty(a:pairs)
	echomsg "Usage:  :RepmoMap {motion}|{rev-motion} ... [<unique>] ..."
	return
    endif
    let unique = 0
    for pair in split(a:pairs)
	let keys = split(pair, "|")
	if len(keys) == 2
	    call RepmoMap(keys[0], keys[1], unique)
	    call RepmoMap(keys[1], keys[0], unique)
	elseif pair == "<unique>"
	    let unique = 1
	else
	    echomsg 'Repmo: bad key pair "'. strtrans(pair). '"'
	endif
    endfor
endfunc "}}}

" Commands: {{{1
" map motions to be repeatable:
com! -nargs=* RepmoMap call s:CreateMappings(<q-args>)

" Do Inits: {{{1
if g:repmo_mapmotions != ""
    exec "RepmoMap" g:repmo_mapmotions
endif

" Modeline: {{{1

let &cpo = s:sav_cpo
unlet s:sav_cpo

" Feeling:
"   The script might look a bit bloated for such a little thing, but this is
"   due the work done to make the actual mappings lightweight.  For example,
"   if you type "jjjjj", then only the first "j" will call the big function
"   MapRepeatMotion(), the others call MapRepMo().  ";" and "," are always
"   mapped directly to what they are going to repeat.

" vim:set fdm=marker ts=8:
