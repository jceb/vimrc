set encoding=utf-8
let g:neovide_cursor_animation_length=0

" plugin configuration
packadd myconfig_1_pre

lua require('plugins')
autocmd BufWritePost plugins.lua source <afile> | PackerCompile

" " load matchup plugin before matchit
" packadd matchup

function! s:init()
    " personal vim settings
    packadd myconfig_2_post

    " workaround because the event isn't triggered by the above command for some
    " unknown reason
    doau ColorScheme

    let g:my_gui_font = "JetBrainsMono Nerd Font:h9"
    exec ":set guifont=".fnameescape(g:my_gui_font)
    command! GuiFontBigger  :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)+1', ''))
    command! GuiFontSmaller :exec ":set guifont=".fnameescape(substitute(&guifont, '\d\+$', '\=submatch(0)-1', ''))
    nnoremap <silent> <C-0> :<C-u>exec ":set guifont=".fnameescape(g:my_gui_font)<CR>
    nnoremap <silent> <C--> :<C-u>GuiFontSmaller<CR>
    nnoremap <silent> <C-8> :<C-u>GuiFontSmaller<CR>
    nnoremap <silent> <C-ScrollWheelDown> :<C-u>GuiFontSmaller<CR>
    nnoremap <silent> <C-=> :<C-u>GuiFontBigger<CR>
    nnoremap <silent> <C-+> :<C-u>GuiFontBigger<CR>
    nnoremap <silent> <C-9> :<C-u>GuiFontBigger<CR>
    nnoremap <silent> <C-ScrollWheelUp> :<C-u>GuiFontBigger<CR>

    " set SSH environment variable in case it isn't set, e.g. in nvim-qt
    if getenv('SSH_AUTH_SOCK') == v:null
        call setenv('SSH_AUTH_SOCK', systemlist('gpgconf --list-dirs agent-ssh-socket')[0])
    endif
endfunction

if v:vim_did_enter
    call s:init()
else
    au VimEnter * call s:init()
endif
