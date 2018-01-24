set encoding=utf-8

" plugin configuration
packadd myconfig_1_pre

" " load matchup plugin before matchit
" packadd matchup

function! s:init()
    " personal vim settings
    packadd myconfig_2_post

    " set color scheme
    colorscheme PaperColor

    " load status line
    packadd lightline
endfunction

au VimEnter * call s:init()
