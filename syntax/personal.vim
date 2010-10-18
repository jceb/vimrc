" ---------- personal highlightings ----------

" highlight printmargin
"let x=&textwidth + 1
"hi def rightMargin  ctermbg=green guibg=green
"exe 'syn match rightMargin "\%' . &textwidth . 'c.\%' . x . 'c"'

" highlight trailing spaces
syn match Search "[\t ]\+$"
