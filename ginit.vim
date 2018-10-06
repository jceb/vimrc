GuiFont Hack:h8
GuiLinespace 0
let g:gonvim_draw_statusline = 0

command! GuiFontBigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! GuiFontSmaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" plugin configuration
packadd myconfig_1_pre

let g:PaperColor_Theme_Options['theme']['default.light']['transparent_background'] = 0
" hi clear Blinds

" set laststatus=0
set background=light
