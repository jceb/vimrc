" helpwrapper.vim -- Wrap several different help systems within one shortcut
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2010-08-14
" @Last Modified: Fri 06. May 2011 13:36:02 +0900 JST
" @Revision     : 1.1
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Helpwrapper makes it easy to access help from within a
"                 buffer. It takes the file type and opens help when requested
"                 via <leader>K or :Help command.
" @Usage        : <leader>K oder :Help
" @TODO         :
" @Dependency   :
" @CHANGES      :

if &cp || exists("loaded_helpwrapper")
    finish
endif
let loaded_helpwrapper = 1

if !exists('g:helpwrapper_ft_mappings')
	let g:helpwrapper_ft_mappings = {'help': ':help', 'vim': ':help', 'python': ':Pydoc', 'man': ':Man', 'sh': ':Man'}
endif

if !exists('g:helpwrapper_fn_mappings')
	let g:helpwrapper_fn_mappings = {'__doc__': ':Pydoc'}
endif

if !exists('g:helpwrapper_default_ft')
	let g:helpwrapper_default_ft = 'sh'
endif

function! s:OpenHelp(cmd, visual, query)
	try
		if len(a:query)
			exec a:cmd.' '.a:query
		elseif a:visual
			exec a:cmd.' '.@*
		else
			exec a:cmd.' '.expand('<cword>')
		endif
	catch
		echom 'Executing help command failed: '.v:exception
	endtry
endfunction

function! s:Helpwrapper(visual, query)
	" support for files with multiple filetypes
	let fts = split(&ft, '\.')

	let opened_help = 0
	if has_key(g:helpwrapper_fn_mappings, expand('%:t')) && index([1, 2], exists(g:helpwrapper_fn_mappings[expand('%:t')])) != -1
		" first test if a mapping for the filename exists
		call s:OpenHelp(g:helpwrapper_fn_mappings[expand('%:t')], a:visual, a:query)
		let opened_help = 1
	else
		" test if a mapping for the filetype exists
		for ft in fts
			if has_key(g:helpwrapper_ft_mappings, ft) && index([1, 2], exists(g:helpwrapper_ft_mappings[ft])) != -1
				call s:OpenHelp(g:helpwrapper_ft_mappings[ft], a:visual, a:query)
				let opened_help = 1
				break
			endif
		endfor
	endif

	if ! opened_help
		if has_key(g:helpwrapper_ft_mappings, g:helpwrapper_default_ft) &&  index([1, 2], exists(g:helpwrapper_ft_mappings[g:helpwrapper_default_ft])) != -1
			" use default wrapper if no other mapping was found
			call s:OpenHelp(g:helpwrapper_ft_mappings[g:helpwrapper_default_ft], a:visual, a:query)
		else
			echom 'Unable to find help command for file type '.&ft
		endif
	endif
endfunction

nnoremap <leader>K :call <SID>Helpwrapper(0, '')<CR>
vnoremap <leader>K :call <SID>Helpwrapper(1, '')<CR>
command! -nargs=1 -complete=help Help :call <SID>Helpwrapper(0, <q-args>)
