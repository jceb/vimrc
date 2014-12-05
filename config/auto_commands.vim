" Autocommands:
" -------------

if ! has('autocmd')
	finish
endif

augroup ft_text
	au FileType debchangelog,yaml				setlocal shiftwidth=2 softtabstop=2 tabstop=2
	au FileType debchangelog,gitcommit,hg	setlocal spell spelllang=en
	au FileType debchangelog,yaml			setlocal expandtab
	au FileType help						setlocal nolist textwidth=0
	au FileType man							setlocal nolist
	au FileType org							setlocal foldminlines=0 foldlevel=1
	au FileType tex,plaintex				setlocal makeprg=pdflatex\ \'%:p\'
	au FileType mail,help,debchangelog,tex,plaintex,txt,asciidoc,mkd,org		setlocal expandtab iskeyword+=- textwidth=72
	au FileType help,debchangelog,tex,plaintex,txt,asciidoc,mkd,org		setlocal formatoptions=ltcrqn
	au FileType org							setlocal textwidth=77
	au FileType mail						call formatmail#FormatMail() | setlocal cpoptions+=J formatoptions-=l comments+=b:-- spell spelllang=de iskeyword+=-
augroup END

augroup ft_programming
	au!
	au FileType java,c,cpp,python,automake,make	setlocal noexpandtab nosmarttab
	au FileType python						setlocal ts=4 sw=4 " See PEP 8
	au FileType ruby						setlocal ts=2 sw=2
	au FileType xml,docbk,xhtml,jsp			setlocal formatoptions=lcrq
augroup END

augroup general
	au!
	au BufReadPost,BufNewFile *				setlocal cpoptions+=J formatoptions-=o formatoptions+=j " o is really annoying
augroup END
