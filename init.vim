set encoding=utf-8

" plugin configuration
packadd myconfig_1_pre

" load matchup plugin before matchit
packadd matchup

" set color scheme
colorscheme PaperColor

function! s:init()
    " personal vim settings
    packadd myconfig_2_post

    " load status line
    packadd lightline
endfunction

au VimEnter * call s:init()
