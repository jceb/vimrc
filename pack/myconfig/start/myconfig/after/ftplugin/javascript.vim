" install javascript beautify: npm install js-beautify
if executable('js-beautify')
    let &l:formatprg = 'js-beautify -f - -j --editorconfig'
endif
