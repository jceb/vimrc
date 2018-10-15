" Autocommands:
" -------------

if ! has('autocmd')
	finish
endif

augroup ft_text
  au!
  " au FileType *							setlocal iskeyword+=_
  au FileType mail,help,debchangelog,tex,plaintex,txt,asciidoc,markdown,org
        \ setlocal formatoptions=t iskeyword+=- textwidth=72 complete+=kspell
        \ | packadd thesaurus_query
  au FileType debchangelog,yaml			setlocal shiftwidth=2 softtabstop=2 tabstop=2
  au FileType debchangelog,gitcommit,hg	setlocal spell spelllang=en
  au FileType help						setlocal nolist textwidth=0
  au FileType help						nnoremap <buffer> q :q<cr> " close help buffer by just pressing q
  au FileType man						setlocal nolist
  au FileType org						setlocal foldminlines=0 foldlevel=1
  au FileType tex,plaintex				setlocal makeprg=pdflatex\ \'%:p\'
  au FileType asciidoc					setlocal formatlistpat=^\\s*\\([:alnum:]\\+\\.\\\|-\\\|[.*]\\+\\)\\s\\+
  au FileType org						setlocal textwidth=77
  au FileType mail						setlocal textwidth=0 wrap cpoptions+=J commentstring=>%s comments+=b:-- spell spelllang=de formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\|[-*#]\\)\\s* | call formatmail#FormatMail()
augroup END

augroup ft_programming
  au!
  au FileType dosbatch					setlocal commentstring=::\ %s
  au FileType solidity					setlocal comments=://
  au FileType javascript				setlocal ts=2 sw=2 sts=2
  " au FileType java,c,cpp,python,automake,make	setlocal noexpandtab nosmarttab
  " au FileType python						setlocal sts=4 ts=4 sw=4 " See PEP 8
  " au FileType ruby						setlocal sts=2 ts=2 sw=2
  au FileType python					setlocal omnifunc=python3complete#Complete textwidth=79
  au FileType c							setlocal commentstring=/*%s*/
  au FileType cpp						setlocal commentstring=//%s
  au FileType vue						setlocal shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup ft_general
  au!
  au BufReadPost,BufNewFile *.hbs		setf html
  au BufReadPost,BufNewFile neomutt-*	setf mail
  au BufReadPost,BufNewFile *			setlocal cpoptions+=J formatoptions+=rcjnq formatoptions-=o " o is really annoying
  au FocusGained *						checktime " run checks like autoread as soon as vim regains focus
augroup END
