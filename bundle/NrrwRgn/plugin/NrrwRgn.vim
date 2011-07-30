" NrrwRgn.vim - Narrow Region plugin for Vim
" -------------------------------------------------------------
" Version:	   0.21
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Tue, 26 Jul 2011 09:06:42 +0200
"
" Script: http://www.vim.org/scripts/script.php?script_id=3075 
" Copyright:   (c) 2009, 2010 by Christian Brabandt
"			   The VIM LICENSE applies to histwin.vim 
"			   (see |copyright|) except use "NrrwRgn.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 3075 21 :AutoInstall: NrrwRgn.vim
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
	call nrrwrgn#Debug(1)
endif

" ------------------------------------------------------------------------------
" Public Interface: {{{1

" Define the Command aliases "{{{2
com! -range NRPrepare :<line1>,<line2>NRP
com! -range NarrowRegion :<line1>,<line2>NR
com! NRMulti :NRM
com! NarrowWindow :NW

" Define the actual Commands "{{{2
com! -range NR	 :<line1>, <line2>call nrrwrgn#NrrwRgn()
com! -range NRP  :exe ":" . <line1> . ',' . <line2> . "call nrrwrgn#Prepare()"
com! NRV :call nrrwrgn#VisualNrrwRgn(visualmode())
com! NUD :call nrrwrgn#UnifiedDiff()
com! NW	 :exe ":" . line('w0') . ',' . line('w$') . "call nrrwrgn#NrrwRgn()"
com! NRM :call nrrwrgn#NrrwRgnDoPrepare()

" Define the Mapping: "{{{2
if !hasmapto('<Plug>NrrwrgnDo')
	xmap <unique> <Leader>nr <Plug>NrrwrgnDo
endif
xnoremap <unique> <script> <Plug>NrrwrgnDo <sid>VisualNrrwRgn
xnoremap <sid>VisualNrrwRgn :<c-u>call nrrwrgn#VisualNrrwRgn(visualmode())<cr>

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
