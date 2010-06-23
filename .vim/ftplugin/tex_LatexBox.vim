" LaTeX Box plugin for Vim
" Maintainer: David Munger
" Email: mungerd@gmail.com
" Version: 0.8.3
" - Load errors automatically when latexmk exits with nonzero status
" - Fixed a stupid bug that would prevent in bibtex completion

if !exists('s:loaded')

	let prefix = expand('<sfile>:p:h') . '/latex-box/'

	execute 'source ' . fnameescape(prefix . 'common.vim')
	execute 'source ' . fnameescape(prefix . 'complete.vim')
	execute 'source ' . fnameescape(prefix . 'motion.vim')
	execute 'source ' . fnameescape(prefix . 'latexmk.vim')

	let s:loaded = 1

endif

execute 'source ' . fnameescape(prefix . 'mappings.vim')

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4
