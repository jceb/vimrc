" Vim plugin -- repeat motions for which a count was given
" General: {{{1
" File:         repmo.vim
" Created:      2008 Jan 27
" Last Change:  2009 Jun 03
" Rev Days:     7
" Author:	Andy Wokula <anwoku@yahoo.de>
" Version:	0.5

" Question: BML schrieb: Is there a way/command to repeat the last movement,
"   like ; and , repeat the last f command? It would be nice to be able to
"   select the 'scrolling' speed by typing 5j or 8j, and then simply hold
"   down a key and what the text scroll by at your given speed. Ben
" Answer: No there isn't, but an exception is  :h 'scroll
"   Or take repmo.vim as an answer.  It uses the keys "<Space>" and "<BS>" to
"   repeat motions.

" Usage By Example:
"   Type "5j" and then ";" to repeat "5j" (after  :RepmoMap j k ).
"   Type "hjkl" and then ";", it still repeats "5j".
"   Type "," to do "5k" (go in reverse direction).
"   Type "4k" and then ";" to repeat "4k" (after  :RepmoMap k j ).
"
"   The following motions (and scroll commands) are mapped per default:
"	j,k h,l <C-e>,<C-y> <C-d>,<C-u> <C-f>,<C-b> zh,zl w,b W,B e,ge E,gE (,) {,} [[,]]
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
"   g:repmo_mapmotions	    (string)	"j|k h|l <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]]"	    when sourced
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
" key notation is like in mappings:
" let g:repmo_key = ";"
" let g:repmo_revkey = ","
if ! exists("g:repmo_key") || g:repmo_key != ''
    let g:repmo_key = '<Space>'
endif
if ! exists("g:repmo_revkey") || g:repmo_revkey != ''
    let g:repmo_revkey = '<BS>'
endif

" motions to map per default
if !exists("g:repmo_mapmotions")
    let g:repmo_mapmotions = "j|k h|l <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]]"
    " use "<bar>" to map "|"
endif

" Repeat Mappings: {{{1
exec "noremap <special> <silent>" g:repmo_key ":<c-u>call <sid>RepMo(0, 0)<CR>"
exec "xnoremap <special> <silent>" g:repmo_key ":<c-u>call <sid>RepMo(1, 0)<CR>"
exec "noremap <special> <silent>" g:repmo_revkey ":<c-u>call <sid>RepMo(0, 1)<CR>"
exec "xnoremap <special> <silent>" g:repmo_revkey ":<c-u>call <sid>RepMo(1, 1)<CR>"
"}}}

" Functions: {{{1

" Internal Variables: {{{
let s:lastcnt = ""
let s:lastkey = ""
let s:lastrevkey = ""
"}}}

" Internal Mappings: "{{{
nn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(0,
vn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(1,
"}}}

func! <sid>RepMo(vmode, rev) "{{{
    if a:vmode
	normal! gv
    endif
    if s:lastkey == "" || s:lastrevkey == ""
	return
    endif
    exec "normal!" s:lastcnt . eval('"'.escape(a:rev ? s:lastrevkey : s:lastkey, '\<"').'"')
endfunc "}}}

func! <sid>MapRepeatMotion(vmode, key, revkey) "{{{
    " map ";" and ","
    " remap the motion a:key to something simpler than this function
    if a:vmode
	normal! gv
    endif
    let cnt = v:count
    let rawkey = eval('"'.escape(a:key, '\<"').'"')
    let whitecnt = (rawkey=~'^\s$' ? "1" : "")

    let s:lastcnt = cnt >= 1 ? cnt : whitecnt
    let s:lastkey = a:key
    let s:lastrevkey = a:revkey

    exec "normal!" s:lastcnt . rawkey
endfunc "}}}

func! s:RepmoMap(key, revkey, ...) abort "{{{
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

func! s:CreateMappings(pairs) "{{{
    if empty(a:pairs)
	echomsg "Usage:  :RepmoMap {motion}|{rev-motion} ... [<unique>] ..."
	return
    endif
    let unique = 0
    for pair in split(a:pairs)
	let keys = split(pair, "|")
	if len(keys) == 2
	    call s:RepmoMap(keys[0], keys[1], unique)
	    call s:RepmoMap(keys[1], keys[0], unique)
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
