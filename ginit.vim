if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    set guifont=JetBrains\ Mono:h8
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <C-0> :<C-u>set guifont=JetBrains\ Mono:h8<CR>
    nnoremap <C--> :<C-u>set guifont=-<CR>
    nnoremap <silent> <C-ScrollWheelDown> :<C-u>set guifont=-<CR>
    nnoremap <C-=> :<C-u>set guifont=+<CR>
    nnoremap <C-+> :<C-u>set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelUp> :<C-u>set guifont=+<CR>
    " nnoremap <A-CR> :FVimToggleFullScreen<CR>

    FVimFontAutohint v:false
    FVimFontHintLevel 'slight'
    FVimFontAutoSnap v:true
else
    let g:my_gui_font = "JetBrains Mono:h9"

    exec ":GuiFont! ".g:my_gui_font
    GuiLinespace 0

    command! GuiFontBigger  :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', '')
    command! GuiFontSmaller :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', '')

    nnoremap <C-0> :<C-u>exec ":GuiFont ".g:my_gui_font<CR>
    nnoremap <C--> :<C-u>GuiFontSmaller<CR>
    nnoremap <silent> <C-ScrollWheelDown> :<C-u>GuiFontSmaller<CR>
    nnoremap <C-=> :<C-u>GuiFontBigger<CR>
    nnoremap <C-+> :<C-u>GuiFontBigger<CR>
    nnoremap <silent> <C-ScrollWheelUp> :<C-u>GuiFontBigger<CR>

    " somehow the colorscheme isn't set properly
    " let g:PaperColor_Theme_Options['theme']['default.light']['transparent_background'] = 0
    " set background=light

    " ColorschemePaperColor
    " ColorschemeOneLight
    " ColorschemeOne
endif
