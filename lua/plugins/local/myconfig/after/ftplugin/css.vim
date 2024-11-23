" install javascript beautify: npm install js-beautify
if executable('css-beautify')
    let &l:formatprg = 'css-beautify -f-  --editorconfig'
endif
