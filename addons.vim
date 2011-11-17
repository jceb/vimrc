" Vim Addon Manager:
" ------------------

if ! exists('g:vimrc_plugins_loaded')
	"filetype off        " deactivate filetype auto detection before loading bundles to force a reload (this decreases startup time a lot!)
	let sep = pathogen#separator()
	if has('unix')
		call pathogen#infect($HOME.sep.'.vim'.sep.'bundle')
		call ipi#inspect($HOME.sep.'.vim'.sep.'ipi')
	else
		call pathogen#infect($HOME.sep.'vimfiles'.sep.'bundle')
		call ipi#inspect($HOME.sep.'vimfiles'.sep.'ipi')
	endif

	filetype plugin indent on        " activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
endif

let g:vimrc_plugins_loaded = 1
