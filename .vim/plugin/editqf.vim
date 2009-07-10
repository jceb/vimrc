" editqa.vim -- makes editing of the quickfix window easy
" @Author       : Jan Christoph Ebersbach (jceb@tzi.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2008-11-28
" @Last Modified: Tue 30. Dec 2008 22:45:48 +0100 CET
" @Revision     : 0.2
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Makes Quickfix List easily changeable 
" @Usage        : Just press 'i' when you are in the quickfix window and save the changed buffer, that's it
" @TODO         :
" @Dependency   : Depends on qfn.vim plugin
" @CHANGES      :

if &cp || exists("loaded_editqf")
    finish
endif
let loaded_editqf = 1

function! <SID>Cleanup (loadqf)
	if exists ('g:qfile') && filewritable (g:qfile)
		au! BufLeave,BufWritePost <buffer>
		exec 'bw! '.bufnr('%')
		if a:loadqf != 0
			exec 'cgetfile '.g:qfile
		endif
		call delete (g:qfile)
		exec 'cc '.g:qf_line
		unlet! g:qfile
		unlet! g:qf_line
	endif
endfunction

function! <SID>EditQF ()
	let g:qf_line = line ('.')
	let col = col ('.')
	let g:qfile = tempname ()
	exec 'QFNSave '.g:qfile
	exec 'normal s'
	exec 'silent! e '.g:qfile
	exec 'normal '.g:qf_line.'G'
	exec 'normal 0'.col.'l'
	au BufWritePost <buffer> :call <SID>Cleanup (1)
	au BufLeave <buffer> :call <SID>Cleanup (0)
endfunction
au BufReadPost quickfix nnoremap <silent> <buffer> i :if !exists ("g:qfile")<Bar>call <SID>EditQF()<Bar>endif<CR>
