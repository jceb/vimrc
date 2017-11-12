let b:fts = ['xhtml', 'javascript', 'css']
let b:curft = 1

nnoremap <silent> <buffer> <F10> :exec ':setf ' . b:fts[b:curft] . '\|:let b:curft = (1 + ' . b:curft . ')%' . len(b:fts)<CR>

" generate a tag out of the current word
nnoremap czt "zyiwciw<<C-r>z></<C-r>z><C-o>F<
nnoremap czz "zyiwciw<<C-r>z><CR></<C-r>z><C-o>O

" install javascript beautify: npm install js-beautify
if executable('html-beautify')
    let &l:formatprg = 'html-beautify -f - -I --editorconfig'
endif
