" install javascript beautify: npm install javascript-beautify
if executable('css-beautify')
    let &l:formatprg = 'css-beautify -f - -s ' . &shiftwidth
endif
