" ipi.vim - individual plugin initiator
" Maintainer:   Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:      1.3
" Source:       http://www.github.com/jceb/vim-ipi
" Download:     http://www.vim.org/scripts/script.php?script_id=3809

" This plugin is very much inspired by Tim Pope's pathogen plug-in. vim-ipi
" adds the functionality of loading infrequently used plugins later. This
" greatly helps in cutting down vim's start-up time.
"
" Installation:
" Install vim-ipi in ~/.vim/autoload (or ~\vimfiles\autoload), together with
" pathogen (http://www.vim.org/scripts/script.php?script_id=2332).
"
" Pathogen's settings can be used to configure ipi as well, e.g. disable
" plugins (g:pathogen_disabled).
"
" For loading plugins later, install them in ~/.vim/ipi (or ~\vimfiles\ipi)
" and  add `call ipi#inspect()` to .vimrc. This will create a list of plugins
" that can be loaded later by using the IP command:
"
" Examples:
" Load gundo plugin later:
" :IP gundo
"
" Load gundo and speeddating plugins later:
" :IP gundo speedating
"
" Load all known plugins later:
" :IP!
"
" A very high level of convenience can be achieved by loading the plug-ins
" automatically right before using their functionality. Here is an example for
" the gundo plug-in. I just prefixed the mapping with ":silent! IP gundo<CR>":
" nmap <leader>u :silent! IP gundo<CR>:GundoToggle<CR>
"
" Tips:
" Some plugins use the autocommand VimEnter to do some initialization. ipi
" has built-in support for a number of plugins that use this feature. A
" detailed description is provided for the g:ipi_vimenter_autocommand
" variable.  In case a plugin is not support yet, manual execution of the
" autocommand can be done by running the following command:
" :do <AUTOGROUPNAME> VimEnter
"
" For the convenience wrapper it would look like this:
" nmap <leader>f :silent! IP NERDTree<CR>:do NERDTree VimEnter<CR>:NERDTree<CR>
"
" Todo:
" TODO provide a menu entry for selecting the plugins

if exists("g:loaded_ipi") || &cp
  finish
endif
let g:loaded_ipi = 1

if ! exists('g:ipi_vimenter_autocommand')
	" Mapping of plugin names to the autocommand group that contains the
	" VimEnter autocommand. For every listed plugin the specified autocommand
	" group is executed. Plugin names are matched against the directory names
	" converted to lower case and all non-alpha characters removed.
	let g:ipi_vimenter_autocommand = {
				\ 'fugitive': 'fugitive_utility',
				\ 'nerdtree': 'NERDTree',
				\ 'session': 'PluginSession',
				\ 'yankring': 'YankRing'
				\ }
endif

let s:lp = {}

" get a list of the plugins that shall be loaded later
function! ipi#inspect(...) abort
	let source_path = a:0 ? a:1 : 'ipi'
	let sep = pathogen#separator()
	let list = []
	let rtp = pathogen#split(&rtp)
	if source_path =~# '[\\/]'
		let list +=  filter(pathogen#glob_directories(source_path.sep.'*[^~]'), '!pathogen#is_disabled(v:val)')
	else
		for dir in rtp
			if dir !~# '\<after$'
				let list +=  filter(pathogen#glob_directories(dir.sep.source_path.sep.'*[^~]'), '!pathogen#is_disabled(v:val)')
			endif
		endfor
	endif
	call ipi#difference(list, rtp)
	for i in list
		let s:lp[split(i, sep)[-1]] = i
	endfor
endfunction

" Remove items from a list (lista) that are in the other list (listb). Also
" make list items in lista unique.
function! ipi#difference(lista, listb) abort
	call pathogen#uniq(a:lista)
	for i in a:listb
		let idx = index(a:lista, i)
		if idx >= 0
			call remove(a:lista, idx)
		endif
	endfor
	return a:lista
endfunction

" source vim files found in path
function! ipi#source(path) abort
	let sep    = pathogen#separator()
	" source the files found in the plugin directory
	if isdirectory(a:path)
		for f in pathogen#glob(a:path.sep.'*.vim')
			if filereadable(f)
				exec 'source '.fnameescape(f)
			endif
		endfor
	endif
endfunction

" Load plugin located in path and execute all vim files found in the
" plugin directory
function! ipi#load(path, plugin) abort
	let path = expand(a:path)
	if ! isdirectory(path)
		echoe fnameescape(path)." is not a directory"
		return
	endif
	let sep    = pathogen#separator()
	let before = [path]
	let after = []
	if isdirectory(path.sep.'after')
		call add(after, path.sep.'after')
	endif
	let rtp = pathogen#split(&rtp)
	call filter(rtp,'v:val[0:strlen(path)-1] !=# path')
	let &rtp = pathogen#join(pathogen#uniq(before + rtp + after))

	call ipi#source(path.sep.'plugin')
	call ipi#source(path.sep.'ftdetect')
	call ipi#source(path.sep.'after'.sep.'plugin')
	call ipi#source(path.sep.'after'.sep.'ftdetect')

	" execute autocommand VimEnter for known plugins
	let p = substitute(tolower(a:plugin), '[^a-z]', '', 'g')
	if has_key(g:ipi_vimenter_autocommand, p)
		exec "do ".g:ipi_vimenter_autocommand[p]." VimEnter"
	endif
	return &rtp
endfunction

function! s:InitiatePlugins(bang, ...) abort
	let plugins = {}
	let notfound = []
	if a:bang == '!'
		let plugins = copy(s:lp)
		let s:lp = {}
	else
		for p in a:000
			if ! has_key(s:lp, p)
				call add(notfound, p)
			else
				let plugins[p] = s:lp[p]
				call remove(s:lp, p)
			endif
		endfor
	endif
	for p in keys(plugins)
		if index(notfound, p) == -1
			call ipi#load(plugins[p], p)
		endif
	endfor

	if len(plugins) == 0 && a:bang == ''
		echom 'No plugins loaded.'
	"elseif len(plugins) == 1
	"	echom 'Loaded plugin: '.keys(plugins)[0]
	"else
	"	echom 'Loaded plugins: '.join(keys(plugins), ' ')
	endif
	if len(notfound) > 0 && a:bang == ''
		echom 'Unable to find plugin(s): '.join(notfound, ' ')
	endif
endfunction

function! s:ListPlugins(A, L, P) abort
	let found = {}
	for p in keys(s:lp)
		if p =~ '^'.a:A
			let found[p] = 1
		endif
	endfor
	return sort(keys(found))
endfunction

command! -bang -nargs=* -complete=customlist,s:ListPlugins IP :call s:InitiatePlugins("<bang>", <f-args>)
