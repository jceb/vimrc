set encoding=utf-8

" plugin configuration
packadd myconfig_1_pre

" " load matchup plugin before matchit
" packadd matchup

function! s:init()
    if exists("g:gonvim_running")
        echom gonvim
        let g:PaperColor_Theme_Options['theme']['default.light']['transparent_background'] = 0
        hi clear Blinds

        set laststatus=0
        set background=light
    endif

    " set color scheme
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
