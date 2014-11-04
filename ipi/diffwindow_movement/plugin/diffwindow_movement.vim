" diffwindow_movement.vim: Movement over changes in a diff window.
"
" DEPENDENCIES:
"   - CountJump/Region/Motion.vim autoload script
"   - CountJump/TextObjects.vim autoload script
"   - diffwindow_movement.vim autoload script
"
" Copyright: (C) 2011-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.02.003	22-Jul-2014	Introduce configuration variables to be able to
"				reconfigure the mappings.
"   1.01.002	02-Mar-2012	FIX: Vim 7.0/1 need preloading of functions
"				referenced in Funcrefs.
"   1.00.001	30-Aug-2011	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_diffwindow_movement') || (v:version < 700)
    finish
endif
let g:loaded_diffwindow_movement = 1
if v:version < 702 | runtime autoload/diffwindow_movement.vim | endif

"- configuration ---------------------------------------------------------------

if ! exists('g:diffwindow_movement_EndMapping')
    let g:diffwindow_movement_EndMapping = 'C'
endif
if ! exists('g:diffwindow_movement_ChangeTextObject')
    let g:diffwindow_movement_ChangeTextObject = 'c'
endif
if ! exists('g:diffwindow_movement_DifferenceTextObject')
    let g:diffwindow_movement_DifferenceTextObject = 'd'
endif


"- mappings --------------------------------------------------------------------

call CountJump#Region#Motion#MakeBracketMotion('', '', g:diffwindow_movement_EndMapping, function('diffwindow_movement#IsDiffLine'), 1)


call CountJump#Region#TextObject#Make('', g:diffwindow_movement_ChangeTextObject, 'i', 'V', function('diffwindow_movement#IsDiffLine'), 1)

"			Note: [count] doesn't make so much sense here.
call CountJump#Region#TextObject#Make('', g:diffwindow_movement_DifferenceTextObject, 'i', 'V', function('diffwindow_movement#IsDifferenceLine'), 1)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
