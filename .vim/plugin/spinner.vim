if &cp || exists("g:loaded_spinner")
    finish
endif
let g:loaded_spinner = 1

let s:save_cpo = &cpo
set cpo&vim

let s:modes = [
            \    'buffer',
            \    'same_directory_file',
            \    'most_recently_edited',
            \    'tab',
            \    'window',
            \    'quickfix',
            \    'quickfix_file',
            \ ]
let s:mode_count = len(s:modes)

" initial type
if exists('g:spinner_initial_search_type')
    let s:current_mode = g:spinner_initial_search_type - 1
else
    let s:current_mode = 0
endif

" mapping
if exists('g:spinner_nextitem_key')
    let s:nextitem_map = g:spinner_nextitem_key
else
    let s:nextitem_map = '<c-cr>'
endif

if exists('g:spinner_previousitem_key')
    let s:previousitem_map = g:spinner_previousitem_key
else
    let s:previousitem_map = '<s-cr>'
endif

if exists('g:spinner_switchmode_key')
    let s:switchmode_map = g:spinner_switchmode_key
else
    let s:switchmode_map = '<c-s-cr>'
endif

if exists('g:spinner_displaymode_key')
    let s:displaymode_maps = [ g:spinner_displaymode_key ]
else
    let s:displaymode_maps = [
                \ '<m-cr>',
                \ '<a-cr>',
                \ '<d-cr>',
                \ ]
endif


let s:next_cmd = ""
let s:previous_cmd = ""

" set custom mapping
execute 'nnoremap ' . s:nextitem_map .     ' :<c-u>call g:NextSpinnerItem()<cr>'
execute 'nnoremap ' . s:previousitem_map . ' :<c-u>call g:PreviousSpinnerItem()<cr>'
execute 'nnoremap ' . s:switchmode_map .   ' :<c-u>call g:SwitchSpinnerMode(v:count)<cr>'
for i in s:displaymode_maps
    execute 'nnoremap ' . i . ' :<c-u>call g:DisplayCurrentSpinnerMode()<cr>'
endfor

function! g:SwitchSpinnerMode(count)
    if a:count > 0
        let s:current_mode = a:count - 1
    else
        let s:current_mode += 1
    endif

    if s:current_mode < s:mode_count
    else
        let s:current_mode = 0
    endif

    call s:SwitchSpinnerModeTo(s:current_mode)
    echohl None | echo 'switch spinner mode to [' . s:modes[s:current_mode] . '].' | echohl None
endfunction
function! s:SwitchSpinnerModeTo(mode)
    let s:next_cmd = 'call spinner#' . s:modes[a:mode] . '#next()'
    let s:previous_cmd = 'call spinner#' . s:modes[a:mode] . '#previous()'
endfunction

function! g:NextSpinnerItem()
    execute s:next_cmd
endfunction
function! g:PreviousSpinnerItem()
    execute s:previous_cmd
endfunction

function! g:CurrentSpinnerMode()
    return s:modes[s:current_mode]
endfunction
function! g:DisplayCurrentSpinnerMode()
    echohl None | echo 'current spinner mode [' . s:modes[s:current_mode] . '].' | echohl None
endfunction

function! s:InitializeSpinner()
    call s:SwitchSpinnerModeTo(s:current_mode)

    " load plugins
    for i in s:modes
        execute 'call spinner#' . i . '#load()'
    endfor
endfunction
call s:InitializeSpinner()

let &cpo = s:save_cpo
finish

==============================================================================
spinner.vim : fast buffer/file/tab/... switching plugin with only 3 keys.
------------------------------------------------------------------------------
$VIMRUNTIMEPATH/plugin/spinner.vim
$VIMRUNTIMEPATH/doc/spinner.txt
$VIMRUNTIMEPATH/autoload/spinner/buffer.vim
$VIMRUNTIMEPATH/autoload/spinner/most_recently_edited.vim
$VIMRUNTIMEPATH/autoload/spinner/quickfix.vim
$VIMRUNTIMEPATH/autoload/spinner/quickfix_file.vim
$VIMRUNTIMEPATH/autoload/spinner/same_directory_file.vim
$VIMRUNTIMEPATH/autoload/spinner/tab.vim
$VIMRUNTIMEPATH/autoload/spinner/window.vim
==============================================================================
author  : OMI TAKU
url     : http://nanasi.jp/
email   : mail@nanasi.jp
version : 2009/12/15 17:00:00
==============================================================================
" vim: set et ft=vim nowrap :
