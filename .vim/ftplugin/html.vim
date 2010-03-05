let b:fts = ['xhtml', 'javascript', 'css']
let b:curft = 1

nnoremap <silent> <buffer> <F10> :exec ':setf ' . b:fts[b:curft] . '\|:let b:curft = (1 + ' . b:curft . ')%' . len(b:fts)<CR>

runtime ftplugin/xml.vim
