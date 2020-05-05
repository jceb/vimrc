set encoding=utf-8

" plugin configuration
packadd myconfig_1_pre

" " load matchup plugin before matchit
" packadd matchup

function! s:init()
    " load status line
    packadd lightline

    " personal vim settings
    packadd myconfig_2_post

    " workaround because the event isn't triggered by the above command for some
    " unknown reason
    doau ColorScheme
endfunction

if v:vim_did_enter
    call s:init()
else
    au VimEnter * call s:init()
endif
