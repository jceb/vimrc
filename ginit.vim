let g:my_gui_font = "Hack:h8"

exec ":GuiFont ".g:my_gui_font
GuiLinespace 0
let g:gonvim_draw_statusline = 0

command! GuiFontBigger  :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', '')
command! GuiFontSmaller :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', '')

nnoremap <C-0> :<C-u>exec ":GuiFont ".g:my_gui_font<CR>
nnoremap <C--> :<C-u>GuiFontSmaller<CR>
nnoremap <C-=> :<C-u>GuiFontBigger<CR>
nnoremap <C-+> :<C-u>GuiFontBigger<CR>

" somehow the colorscheme isn't set properly
let g:PaperColor_Theme_Options['theme']['default.light']['transparent_background'] = 0
set background=light
colorscheme PaperColor
