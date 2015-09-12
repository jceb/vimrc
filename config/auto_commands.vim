" Autocommands:
" -------------

if ! has('autocmd')
	finish
endif

augroup ft_text
	au!
	au FileType debchangelog,yaml			setlocal shiftwidth=2 softtabstop=2 tabstop=2
	au FileType debchangelog,gitcommit,hg	setlocal spell spelllang=en
	au FileType help						setlocal nolist textwidth=0
	au FileType man							setlocal nolist
	au FileType org							setlocal foldminlines=0 foldlevel=1
	au FileType tex,plaintex				setlocal makeprg=pdflatex\ \'%:p\'
	au FileType asciidoc					setlocal formatlistpat=^\\s*\\([:alnum:]\\+\\.\\\|-\\\|[.*]\\+\\)\\s\\+
	au FileType org							setlocal textwidth=77
	au FileType mail						call formatmail#FormatMail()|setlocal cpoptions+=J comments+=b:-- spell spelllang=de iskeyword+=- nonumber
	au FileType help,debchangelog,tex,plaintex,txt,asciidoc,mkd,org		setlocal formatoptions=ltcrqnj nonumber
	au FileType mail,help,debchangelog,tex,plaintex,txt,asciidoc,mkd,org		setlocal iskeyword+=- textwidth=72 complete+=kspell
    au BufReadPre *.adoc					if !exists('g:vimple_version')|delc Vimple|delc MyMaps|nunmap [I|nunmap ]I|IP! Asif vimple|endif
augroup END

augroup ft_programming
	au!
	au FileType java,c,cpp,python,automake,make	setlocal noexpandtab nosmarttab
	au FileType python						setlocal sts=4 ts=4 sw=4 " See PEP 8
	au FileType ruby						setlocal sts=2 ts=2 sw=2
augroup END

augroup ft_general
	au!
	au BufReadPost,BufNewFile *				setlocal cpoptions+=J formatoptions+=j formatoptions-=o " o is really annoying
augroup END
