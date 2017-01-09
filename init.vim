set encoding=utf-8

" plugin configuration
packadd myconfig_pre

function! s:init()
    " personal vim settings
    packadd myconfig_post

    " load status line
    packadd lightline

    " set color scheme
    colorscheme PaperColor
endfunction

au VimEnter * call s:init()
