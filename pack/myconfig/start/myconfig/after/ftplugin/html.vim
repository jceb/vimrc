let b:fts = ['xhtml', 'javascript', 'css']
let b:curft = 1

nnoremap <silent> <buffer> <F10> :exec ':setf ' . b:fts[b:curft] . '\|:let b:curft = (1 + ' . b:curft . ')%' . len(b:fts)<CR>

" generate a tag out of the current word
imap <buffer> <C-f> <Esc>czta
imap <buffer> <C-z> <Esc>czta
nnoremap <buffer> <silent> czt :call CursorWord2Tag(1)<CR>
nnoremap <buffer> <silent> czz :call CursorWord2Tag(0)<CR>

" install javascript beautify: npm install js-beautify
if executable('html-beautify')
    let &l:formatprg = 'html-beautify -f - -I --editorconfig'
endif
