" editqa.vim -- makes editing of the quickfix window easy
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2008-11-28
" @Last Modified: Sat 03. Apr 2010 10:49:39 +0200 CEST
" @Revision     : 0.3
" @vi           : ft=vim:tw=80:sw=4:ts=8
"
" @Description  : Makes Quickfix List easily changeable
" @Usage        : Just press 'i' when you are in the quickfix window, change
"                 the entry as you like and finally save the changed buffer or
"                 leave the window to abandon the changes, that's it
" @TODO         :
" @Dependency   : Depends on qfn.vim plugin
" @CHANGES      :

if &cp || exists("loaded_editqf")
    finish
endif
let loaded_editqf = 1

function! <SID>Cleanup(loadqf)
	if exists('g:qfile') && filewritable(g:qfile)
		au! BufLeave,BufWritePost <buffer>
		if a:loadqf != 0
			let tmp_efm = &efm
			" set efm to the used file format
			set efm=%f:%l:%c:%m
			exec 'cgetfile '.g:qfile
			set efm=tmp_efm
		endif
		if exists('g:qf_bufnr') && bufexists(g:qf_bufnr)
			exec 'bw! '.g:qf_bufnr
		endif
		call delete(g:qfile)
		exec 'cc '.g:qf_line
		unlet! g:qfile
		unlet! g:qf_line
		unlet! g:qf_bufnr
	endif
endfunction

function! <SID>EditQF()
	let g:qf_line = line('.')
	let col = col('.') - 1
	let g:qfile = tempname()
	exec 'QFNSave '.g:qfile
	exec 'silent! '.winheight(0).'sp '.g:qfile
	exec 'normal '.g:qf_line.'G'
	exec 'normal 0' . col . 'l'
	setlocal tw=0
	let g:qf_bufnr = bufnr('')
	au BufWritePost <buffer> :call <SID>Cleanup(1)
	au BufLeave <buffer> :call <SID>Cleanup(0)
endfunction

for i in ['i', 'a', 'c', 's', 'd', 'I', 'A', 'C', 'S', 'D']
	exe 'au BufReadPost quickfix nnoremap <silent> <buffer> '.i.' :if !exists("g:qfile")<Bar>call <SID>EditQF()<Bar>endif<CR>'
endfor
