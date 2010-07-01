" LaTeX Box plugin for Vim
" Maintainer: David Munger
" Email: mungerd@gmail.com
" Version: 0.9.0

if !exists('s:loaded')

	let prefix = expand('<sfile>:p:h') . '/latex-box/'

	execute 'source ' . fnameescape(prefix . 'common.vim')
	execute 'source ' . fnameescape(prefix . 'complete.vim')
	execute 'source ' . fnameescape(prefix . 'motion.vim')
	execute 'source ' . fnameescape(prefix . 'latexmk.vim')

	let s:loaded = 1

endif

execute 'source ' . fnameescape(prefix . 'mappings.vim')
execute 'source ' . fnameescape(prefix . 'indent.vim')

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4
