" install javascript beautify: npm install javascript-beautify
if executable('js-beautify')
    let &l:formatprg = 'js-beautify -f - -j -t -s ' . &shiftwidth
endif
