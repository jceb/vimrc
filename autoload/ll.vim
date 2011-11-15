" ll.vim - load plugins later
" Maintainer:   Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:      0.1

" The plugin is very much inspired by Tim Pope's pathogen and requires
" pathogen.
"
" Install in ~/.vim/autoload (or ~\vimfiles\autoload).
"
" You can use pathogen's settings to also configure ll.
"
" For management of individually installed plugins in ~/.vim/ll (or
" ~\vimfiles\ll), adding `call ll#infect()` to your .vimrc
" prior to `filetype plugin indent on` is the only other setup necessary.
"
" The API is documented inline below.  For maximum ease of reading,
" :set foldmethod=marker

if exists("g:loaded_ll") || &cp
  finish
endif
let g:loaded_ll = 1

let g:plugins = {}

" get a list of the plugins that shall be loaded later
function! ll#infect(...)
	" TODO provide a menu entry for selecting the plugins or a command with proper completion
	let source_path = a:0 ? a:1 : 'll'
	let sep = pathogen#separator()
	let list = []
	let rtp = pathogen#split(&rtp)
	for dir in rtp
		if dir !~# '\<after$'
			let list +=  filter(pathogen#glob_directories(dir.sep.source_path.sep.'*[^~]'), '!pathogen#is_disabled(v:val)')
		endif
	endfor
	call ll#difference(list, rtp)
	for i in list
		let g:plugins[split(i, sep)[-1]] = i
	endfor
endfunction

" Remove items from a list (lista) that are in the other list (listb). Also
" make list items in lista unique.
function! ll#difference(lista, listb) abort " {{{1
	call pathogen#uniq(a:lista)
	for i in a:listb
		let idx = index(a:lista, i)
		if idx >= 0
			call remove(a:lista, idx)
		endif
	endfor
	return a:lista
endfunction " }}}1

function! pathogen#runtime_prepend_subdirectories(path) " {{{1
  let sep    = pathogen#separator()
  let before = filter(pathogen#glob_directories(a:path.sep."*"), '!pathogen#is_disabled(v:val)')
  let after  = filter(pathogen#glob_directories(a:path.sep."*".sep."after"), '!pathogen#is_disabled(v:val[0:-7])')
  let rtp = pathogen#split(&rtp)
  let path = expand(a:path)
  call filter(rtp,'v:val[0:strlen(path)-1] !=# path')
  let &rtp = pathogen#join(pathogen#uniq(before + rtp + after))
  return &rtp
endfunction " }}}1

function ll#load(path)
	" functionality to load plugins later
	" remove plugins from that list when they got loaded
endfunction

function! s:Loadplugins(...)
	echom len(a:000)
	let plugins = {}
	let notfound = []
	if v:cmdbang
		let plugins = g:plugins
	else
		for p in a:000
			if ! has_key(g:plugins, p)
				call add(notfound, p)
			else
				let plugins[p] = g:plugins[p]
				call remove(g:plugins, p)
			endif
		endfor
	endif
	for p in keys(plugins)
		if index(notfound, p) == -1
			call ll#load(plugins[p])
		endif
	endfor

	if len(plugins) == 0
		echom 'No plugins loaded.'
	elseif len(plugins) == 1
		echom 'Loaded plugin: '.keys(plugins)[0]
	else
		echom 'Loaded plugins: '.join(keys(plugins), ' ')
	endif
	if len(notfound) > 0
		echom 'Unable to find plugin(s): '.join(notfound, ' ')
	endif
endfunction

function! s:Listplugins(A, L, P)
	let sep = pathogen#separator()
	let found = {}
	for p in keys(g:plugins)
		if p =~# '^'.a:A
			let found[p] = 1
		endif
	endfor
	"return join(found, '\n')
	return sort(keys(found))
endfunction

command! -bang -nargs=* -complete=customlist,s:Listplugins LL :call s:Loadplugins(<q-args>)
