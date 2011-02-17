" LaTeX Box plugin for Vim
" Maintainer: David Munger
" Email: mungerd@gmail.com
" Version: 0.9.4

if has('*fnameescape')
	function! s:FNameEscape(s)
		return fnameescape(a:s)
	endfunction
else
	function! s:FNameEscape(s)
		return a:s
	endfunction
endif

if !exists('s:loaded')

	let prefix = expand('<sfile>:p:h') . '/latex-box/'

	execute 'source ' . s:FNameEscape(prefix . 'common.vim')
	execute 'source ' . s:FNameEscape(prefix . 'complete.vim')
	execute 'source ' . s:FNameEscape(prefix . 'motion.vim')
	execute 'source ' . s:FNameEscape(prefix . 'latexmk.vim')

	let s:loaded = 1

endif

execute 'source ' . s:FNameEscape(prefix . 'mappings.vim')
execute 'source ' . s:FNameEscape(prefix . 'indent.vim')

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4
