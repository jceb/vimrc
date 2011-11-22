" Plugin Manager:
" ------------------

if exists('g:vimrc_plugins_loaded')
	finish
endif
let g:vimrc_plugins_loaded = 1

" global variables to make life easier when dealing with different
" system environments
let g:sep = pathogen#separator()
let g:vimdir = has('unix') ? '.vim' : 'vimfiles'

"filetype off        " deactivate filetype auto detection before loading bundles to force a reload (this decreases startup time a lot!)
call pathogen#infect('~'.sep.g:vimdir.g:sep.'bundle')
call ipi#inspect('~'.sep.g:vimdir.sep.'ipi')

filetype plugin indent on        " activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
