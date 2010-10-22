" markdown filetype file
if did_filetype()
    finish
endif

augroup filetypedetect
	au BufNewFile,BufRead	*/apache2/*,*/apache/*,*/httpd/*	setfiletype apache
	au BufNewFile,BufRead	build.xml	setfiletype ant
	au BufNewFile,BufRead	.classpath	setfiletype eclipse_classpath

	" latex suite plugin doesn't work well with XIM
	au BufNewFile,BufRead	*.tex		setfiletype tex

	au BufNewFile,BufRead	*.mkd,*.mdwn		setfiletype mkd

	au BufNewFile,BufRead	*.adoc		setfiletype asciidoc

	au BufNewFile,BufRead	*.h			setfiletype c

	au BufNewFile,BufRead	kontact*.tmp,reportbug.*,reportbug-*,muttng-*-\w\+,muttng\w\{6\},*.mail	setfiletype mail
	au BufNewFile,BufRead	*.mail	setlocal wrap fo-=atc

	au BufNewFile,BufRead	.muttngrc*,Muttngrc,muttngrc*,Muttngrc*	setfiletype muttrc

	au BufNewFile,BufRead	.pycmailrc	setfiletype python

	au BufNewFile,BufRead	hg-editor*	setfiletype hg

	au BufNewFile,BufRead	logmsg2	setfiletype cg

	au BufNewFile,BufRead	COMMIT_EDITMSG	setfiletype gitcommit

	" catch all other filetypes as txt
	au BufWinEnter		*		if !exists('b:set_filetype') && strlen(&filetype) == 0 && bufname('%') != '' | setfiletype txt | endif | let b:set_filetype = 1
augroup END
