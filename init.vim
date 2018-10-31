set encoding=utf-8

" plugin configuration
packadd myconfig_1_pre

" " load matchup plugin before matchit
" packadd matchup

function! s:init()
    " set color scheme
    if exists('g:GuiLoaded')
        let g:PaperColor_Theme_Options['theme']['default.light']['transparent_background'] = 0
    endif
    colorscheme PaperColor

    " load status line
    packadd lightline

    " personal vim settings
    packadd myconfig_2_post
endfunction

if v:vim_did_enter
    call s:init()
else
    au VimEnter * call s:init()
endif
