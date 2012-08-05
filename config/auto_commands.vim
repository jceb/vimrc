" Autocommands:
" -------------

if has("autocmd")
	augroup filetypesettings
		" specific settings that apply only to individual file types
		au FileType debchangelog	setlocal shiftwidth=2 expandtab
		au FileType mail			setlocal formatoptions+=a comments+=b:-- spell spelllang=de
		au FileType mail			call formatmail#FormatMail()
		au FileType ruby			setlocal shiftwidth=2
		au FileType help			setlocal nolist textwidth=0
		au FileType org				setlocal foldminlines=0 foldlevel=1
		au FileType python			setlocal tw=79 " See PEP 8

		" general settings that apply to multiple file types
		au FileType tex,plaintex				setlocal makeprg=pdflatex\ \"%:p\"
		au FileType java,c,cpp					setlocal noexpandtab nosmarttab
		au FileType debchangelog,gitcommit,hg	setlocal spell spelllang=en
		au FileType asciidoc,mkd,tex,mail,txt	setlocal textwidth=72
		au FileType xml,docbk,xhtml,jsp			setlocal formatoptions=lcrq
		au FileType help,debchangelog,tex,plaintex,txt,mail,asciidoc,mkd,org	setlocal iskeyword+=- formatoptions=ltcrqn

		au BufReadPost,BufNewFile *		setlocal formatoptions-=o " o is really annoying

		" Special handling of Makefiles
		au FileType automake,make		setlocal list noexpandtab

		" insert a prompt for every changed file in the commit message
		"au FileType svn :1![ -f "%" ] && awk '/^[MDA]/ { print $2 ":\n - " }' %
	augroup END

	augroup hooks
		autocmd!
		" line highlighting in insert mode
		autocmd InsertLeave *		setlocal nocul
		autocmd InsertEnter *		setlocal cul

		" move to the directory of the edited file
		"au BufEnter *		if isdirectory (expand ('%:p:h')) | cd %:p:h | endif

		" jump to last position in the file
		"au BufReadPost *		if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 && line("'\"") > 1 && line("'\"") <= line("$") && &filetype != "mail" | exe "normal g`\"" | endif
		"au BufWinEnter *		if line("'x") > 0 && line("'x") <= line("$") && line("'y") > 0 && line("'y") <= line("$") && &filetype != "mail" | exe "normal g'yztg`x" | endif
		"au BufWinLeave *		if expand('%') !~ '^\[Lusty' && &buftype == '' && &buflisted == 1 && &modifiable == 1 | exec "normal mxHmy" | endif
	augroup END

	"augroup highlight
	"	autocmd!
	"	" make visual mode dark cyan
	"	au FileType *	hi Visual ctermfg=Black ctermbg=DarkCyan gui=bold guibg=#a6caf0
	"augroup END
endif
