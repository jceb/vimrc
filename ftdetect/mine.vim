if did_filetype()
    finish
endif

augroup filetypedetect
	au BufNewFile,BufReadPost	*/apache2/*,*/apache/*,*/httpd/*	set filetype=apache
	au BufNewFile,BufReadPost	build.xml		set filetype=ant
	au BufNewFile,BufReadPost	.classpath		set filetype=eclipse_classpath

	" latex suite plugin doesn't work well with XIM
	au BufNewFile,BufReadPost	*.tex			set filetype=tex
	au BufNewFile,BufReadPost	*.mkd,*.mdwn	set filetype=markdown
	au BufNewFile,BufReadPost	*.txt			set filetype=txt
	au BufNewFile,BufReadPost	*.adoc,*.asciidoc	set filetype=asciidoc

	au BufNewFile,BufReadPost	*.h				set filetype=c

	au BufNewFile,BufReadPost	kontact*.tmp,reportbug.*,reportbug-*,muttng-*-\w\+,muttng\w\{6\},*.mail	set filetype=mail

	au BufNewFile,BufReadPost	.muttngrc*,Muttngrc,muttngrc*,Muttngrc*	set filetype=muttrc

	au BufNewFile,BufReadPost	.pycmailrc,*.py		set filetype=python

	au BufNewFile,BufReadPost	hg-editor*		set filetype=hg
	au BufNewFile,BufReadPost	logmsg2			set filetype=cg
	au BufNewFile,BufReadPost	COMMIT_EDITMSG	set filetype=gitcommit

	" catch all other filetypes as txt
	au BufWinEnter		*		if !exists('b:set_filetype') && strlen(&filetype) == 0 && bufname('%') != '' | set filetype=txt | endif | let b:set_filetype = 1
augroup END
