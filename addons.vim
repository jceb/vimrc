" Vim Addon Manager:
" ------------------

if ! exists('g:vimrc_plugins_loaded')
	"filetype off        " deactivate filetype auto detection before loading bundles to force a reload (this decreases startup time a lot!)
	call pathogen#runtime_append_all_bundles()

	filetype plugin indent on        " activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
endif

let g:vimrc_plugins_loaded = 1
