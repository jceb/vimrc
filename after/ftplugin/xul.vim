let b:fts = ['xul', 'javascript', 'python']
let b:curft = 1

nnoremap <silent> <buffer> <F10> :exec ':setf ' . b:fts[b:curft] . '\|:let b:curft = (1 + ' . b:curft . ')%' . len(b:fts)<CR>

unlet b:did_ftplugin
source ~/.vim/bundle/xml/ftplugin/xml.vim
