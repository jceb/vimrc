" diffwindow_movement.vim: Movement over changes in a diff window. 
"
" DEPENDENCIES:
"   - CountJump/Region/Motion.vim, CountJump/TextObjects.vim autoload scripts.
"   - diffwindow_movement.vim autoload script. 
"
" Copyright: (C) 2011-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   01.01.002	02-Mar-2012	FIX: Vim 7.0/1 need preloading of functions
"				referenced in Funcrefs.
"   01.00.001	30-Aug-2011	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_diffwindow_movement') || (v:version < 700)
    finish
endif
let g:loaded_diffwindow_movement = 1
if v:version < 702 | runtime autoload/diffwindow_movement.vim | endif

"]C			Go to [count] next end of a change. 
"[C			Go to [count] previous end of a change. 
"			These complement the built-in |]c| |[c| commands. 
call CountJump#Region#Motion#MakeBracketMotion('', '', 'C', function('diffwindow_movement#IsDiffLine'), 1)



"ic			"inner change" text object; in a diff window, select
"			[count] changes. 
call CountJump#Region#TextObject#Make('', 'c', 'i', 'V', function('diffwindow_movement#IsDiffLine'), 1)

"id			"inner difference" text object; difference is more
"			fine-granular than diff changes; in a diff window,
"			select a range of lines that have the same
"			DiffAdd/DiffChange/DiffDelete highlighting.
"			Note: [count] doesn't make so much sense here. 
call CountJump#Region#TextObject#Make('', 'd', 'i', 'V', function('diffwindow_movement#IsDifferenceLine'), 1)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
