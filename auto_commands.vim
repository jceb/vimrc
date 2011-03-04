" Autocommands:
" -------------

if has("autocmd")
	augroup filetypesettings
		autocmd!
		" Do word completion automatically
		au FileType debchangelog	setlocal expandtab
		au FileType tex,plaintex	setlocal makeprg=pdflatex\ \"%:p\"
		au FileType java,c,cpp		setlocal noexpandtab nosmarttab
		au FileType mail			setlocal textwidth=72 formatoptions=ltcrqna comments+=b:--
		au FileType mail			call formatmail#FormatMail()
		au FileType txt				setlocal formatoptions=ltcrqn textwidth=72
		au FileType asciidoc,mkd,tex	setlocal formatoptions=ltcrqn textwidth=72
		au FileType xml,docbk,xhtml,jsp	setlocal formatoptions=lcrq
		au FileType ruby			setlocal shiftwidth=2
		au FileType help			setlocal nolist textwidth=0

		au BufReadPost,BufNewFile *		setlocal formatoptions-=o " o is really annoying

		" Special handling of Makefiles
		au FileType automake,make setlocal list noexpandtab

		" insert a prompt for every changed file in the commit message
		"au FileType svn :1![ -f "%" ] && awk '/^[MDA]/ { print $2 ":\n - " }' %
	augroup END

	augroup hooks
		autocmd!
		" line highlighting in insert mode
		autocmd InsertLeave *	set nocul
		autocmd InsertEnter *	set cul

		" move to the directory of the edited file
		"au BufEnter *		if isdirectory (expand ('%:p:h')) | cd %:p:h | endif

		" jump to last position in the file
		au BufReadPost *		if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 && line("'\"") > 1 && line("'\"") <= line("$") && &filetype != "mail" | exe "normal g`\"" | endif

		" jump to last position every time a buffer is entered
		au BufWinEnter *		if line("'x") > 0 && line("'x") <= line("$") && line("'y") > 0 && line("'y") <= line("$") && &filetype != "mail" | exe "normal g'yztg`x" | endif
		au BufWinLeave *		if expand('%') !~ '^\[Lusty' && &buftype == '' && &buflisted == 1 && &modifiable == 1 | exec "normal mxHmy"
	augroup END

	augroup highlight
		autocmd!
		" make visual mode dark cyan
		au FileType *	hi Visual ctermfg=Black ctermbg=DarkCyan gui=bold guibg=#a6caf0
	augroup END
endif
