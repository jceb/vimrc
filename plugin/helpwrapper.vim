" helpwrapper.vim -- Wrap different help systems in one shortcut
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2010-08-14
" @Last Modified: Sat 31. Oct 2015 14:23:41 +0100 CET
" @Revision     : 1.1
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Helpwrapper makes it easy to access help from within a
"                 buffer. It takes the file type and opens help when requested
"                 via K or :Help command.
" @Usage        : K oder :Help
" @TODO         :
" @Dependency   :
" @CHANGES      :

if &cp || exists('g:loaded_helpwrapper')
    finish
endif
let g:loaded_helpwrapper = 1

command! -nargs=1 Docbk :exec ':silent! !x-www-browser http://docbook.org/tdg5/en/html/<args> &' | redraw!
command! -nargs=1 Xslt2 :exec ':silent! !x-www-browser http://www.w3.org/TR/2007/REC-xslt20-20070123/\#element-<args> &' | redraw!

if !exists('g:helpwrapper_commands')
	let g:helpwrapper_commands = {
				\ 'docbk': ':Docbk',
				\ 'man': ':Man',
				\ 'python': ':Pydoc',
				\ 'rfc': ':Rfc',
				\ 'vim': ':help',
				\ 'xslt': ':Xslt2'
				\ }
endif

if !exists('g:helpwrapper_ft_mappings')
	" map file type to help command
	let g:helpwrapper_ft_mappings = {
				\ 'c': 'man',
				\ 'docbk': 'docbk',
				\ 'help': 'vim',
				\ 'man': 'man',
				\ 'python': 'python',
				\ 'rfc': 'rfc',
				\ 'sh': 'man',
				\ 'vim': 'vim',
				\ 'xslt': 'xslt'
				\ }
endif

if !exists('g:helpwrapper_fn_mappings')
	" map file name to help command
	let g:helpwrapper_fn_mappings = {'__doc__': 'python'
				\ }
endif

if !exists('g:helpwrapper_default_command')
	let g:helpwrapper_default_command = 'man'
endif

function! <SID>OpenHelp(cmd, visual, query)
	try
		if strlen(a:query)
			exec a:cmd.' '.a:query
		elseif a:visual
			let l:z = @z
			normal! gv"zy
			exec a:cmd.' '.@z
			let @z = l:z
			unlet l:z
		else
			exec a:cmd.' '.expand('<cword>')
		endif
	catch
		echom 'Executing help command failed: '.v:exception
	endtry
endfunction

" retrieve help command for file type or file name mappings
function! <SID>GetHelp(mapping_dict, help)
	if <SID>HelpAvailable(a:mapping_dict, a:help)
		return <SID>GetHelpCommand(a:mapping_dict[a:help])
	endif
endfunction

" test availability of help command for file type or file name mappings
function! <SID>HelpAvailable(mapping_dict, help)
	return has_key(a:mapping_dict, a:help) &&
				\ <SID>HelpCommandAvailable(a:mapping_dict[a:help])
endfunction

" retrieve help command for a command name
function! <SID>GetHelpCommand(cmd)
	if <SID>HelpCommandAvailable(a:cmd)
		return g:helpwrapper_commands[a:cmd]
	endif
endfunction

" test availability of command for a command name
function! <SID>HelpCommandAvailable(cmd)
	return has_key(g:helpwrapper_commands, a:cmd) &&
				\ index([1, 2], exists(g:helpwrapper_commands[a:cmd])) != -1
endfunction

function! <SID>Helpwrapper(visual, query, ...)
	let opened_help = 0
	if a:0 && strlen(a:1) && <SID>HelpCommandAvailable(a:1)
		call <SID>OpenHelp(<SID>GetHelpCommand(a:1), a:visual, a:query)
		let opened_help = 1
	elseif <SID>HelpAvailable(g:helpwrapper_fn_mappings, expand('%:t'))
		" first test if a mapping for the filename exists
		call <SID>OpenHelp(<SID>GetHelp(g:helpwrapper_fn_mappings, ft), a:visual, a:query)
		let opened_help = 1
	else
		" support for files with multiple filetypes
		let fts = split(&ft, '\.')

		" test if a mapping for the filetype exists
		for ft in fts
			if <SID>HelpAvailable(g:helpwrapper_ft_mappings, ft)
				call <SID>OpenHelp(<SID>GetHelp(g:helpwrapper_ft_mappings, ft), a:visual, a:query)
				let opened_help = 1
				break
			endif
		endfor
	endif

	if ! opened_help
		if <SID>HelpCommandAvailable(g:helpwrapper_default_command)
			" use default wrapper if no other mapping was found
			call <SID>OpenHelp(<SID>GetHelpCommand(g:helpwrapper_default_command), a:visual, a:query)
		else
			echom 'Unable to find help command for file type '.&ft
		endif
	endif
endfunction

nnoremap K :call <SID>Helpwrapper(0, '')<CR>
xnoremap K :call <SID>Helpwrapper(1, '')<CR>

function! <SID>CompleteHelpwrapper(A, L, P)
	let res = []
	let arg_len = strlen(a:A)
	if ! arg_len
		let res = keys(g:helpwrapper_commands)
	else
		for k in keys(g:helpwrapper_commands)
			if k[ : arg_len - 1] == a:A
				call add(res, k)
			endif
		endfor
	endif
	return res
endfunction
command! -nargs=* -complete=customlist,<SID>CompleteHelpwrapper Help :call <SID>Helpwrapper(0, <f-args>)
nnoremap <leader>H :Help 
