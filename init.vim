set encoding=utf-8

" plugin configuration
packadd myconfig_pre

" set color scheme
colorscheme PaperColor

function! s:init()
    " personal vim settings
    packadd myconfig_post

    " load status line
    packadd lightline
endfunction

au VimEnter * call s:init()
