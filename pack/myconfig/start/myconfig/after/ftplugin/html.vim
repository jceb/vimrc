let b:fts = ['xhtml', 'javascript', 'css']
let b:curft = 1

nnoremap <silent> <buffer> <F10> :exec ':setf ' . b:fts[b:curft] . '\|:let b:curft = (1 + ' . b:curft . ')%' . len(b:fts)<CR>

" generate a tag for the current word
imap <C-f> <Esc>cxt
imap <C-z> <Esc>czt
nnoremap cxt "zyiwciw<<C-r>z></<C-r>z><C-o>F<
nnoremap czt "zyiwciw<<C-r>z><CR></<C-r>z><C-o>O
