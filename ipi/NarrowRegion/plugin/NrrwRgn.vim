" NrrwRgn.vim - Narrow Region plugin for Vim
" -------------------------------------------------------------
" Version:	   0.28
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Sun, 03 Jun 2012 13:47:04 +0200
"
" Script: http://www.vim.org/scripts/script.php?script_id=3075
" Copyright:   (c) 2009, 2010 by Christian Brabandt
"			   The VIM LICENSE applies to histwin.vim
"			   (see |copyright|) except use "NrrwRgn.vim"
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 3075 28 :AutoInstall: NrrwRgn.vim
"
" Init: {{{1
let s:cpo= &cpo
if exists("g:loaded_nrrw_rgn") || &cp
  finish
endif
set cpo&vim
let g:loaded_nrrw_rgn = 1

" Debug Setting
let s:debug=0
if s:debug
	exe "call nrrwrgn#Debug(1)"
endif

" ----------------------------------------------------------------------------
" Public Interface: {{{1

" Define the Command aliases "{{{2
com! -range -bang NRPrepare :<line1>,<line2>NRP<bang>
com! -range NarrowRegion :<line1>,<line2>NR
com! NRMulti :NRM
com! NarrowWindow :NW
com! NRLast :NRL

" Define the actual Commands "{{{2
com! -range NR	 :<line1>, <line2>call nrrwrgn#NrrwRgn()
com! -range -bang NRP  :exe ":" . <line1> . ',' . <line2> . 'call nrrwrgn#Prepare(<q-bang>)'
com! NRV :call nrrwrgn#VisualNrrwRgn(visualmode())
com! NUD :call nrrwrgn#UnifiedDiff()
com! NW	 :exe ":" . line('w0') . ',' . line('w$') . "call nrrwrgn#NrrwRgn()"
com! NRM :call nrrwrgn#NrrwRgnDoPrepare()
com! NRL :call nrrwrgn#LastNrrwRgn()

" Define the Mapping: "{{{2
if !hasmapto('<Plug>NrrwrgnDo')
	xmap <unique> <Leader>nr <Plug>NrrwrgnDo
endif
if !hasmapto('VisualNrrwRgn')
	xnoremap <unique> <script> <Plug>NrrwrgnDo <sid>VisualNrrwRgn
endif
xnoremap <sid>VisualNrrwRgn :<c-u>call nrrwrgn#VisualNrrwRgn(visualmode())<cr>

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
