GuiFont Hack:h8
GuiLinespace 0
let g:gonvim_draw_statusline = 0

command! GuiFontBigger  :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', '')
command! GuiFontSmaller :exec ":GuiFont ".substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', '')

nnoremap <C-0> :<C-u>GuiFont Hack:h8<CR>
nnoremap <C--> :<C-u>GuiFontSmaller<CR>
nnoremap <C-=> :<C-u>GuiFontBigger<CR>
nnoremap <C-+> :<C-u>GuiFontBigger<CR>
