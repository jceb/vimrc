" Author: Jan Christoph Ebersbach jceb AT e-jc DOT de

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modeline
set modelines=5

" ########## miscellaneous options ##########
set nocompatible               " Use Vim defaults instead of 100% vi compatibility
set whichwrap=<,>              " Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
set backspace=indent,eol,start " more powerful backspacing
set viminfo='20,\"50           " read/write a .viminfo file, don't store more than
set history=100                " keep 50 lines of command line history
set incsearch                  " Incremental search
set hidden                     " hidden allows to have modified buffers in background
set noswapfile                 " turn off backups and files
set nobackup                   " Don't keep a backup file
set magic                      " special characters that can be used in search patterns
set grepprg=grep\ --exclude='*.svn-base'\ -n\ $*\ /dev/null " don't grep through svn-base files
" Try do use the ack program when available
let tmp = ''
for i in ['ack', 'ack-grep']
	let tmp = substitute (system ('which '.i), '\n.*', '', '')
	if v:shell_error == 0
		exec "set grepprg=".tmp."\\ -a\\ -H\\ --nocolor\\ --nogroup"
		break
	endif
endfor
unlet tmp
"set autowrite                                               " Automatically save before commands like :next and :make
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,.exe
"set autochdir                  " move to the directory of the edited file
set ssop-=options              " do not store global and local values in a session
set ssop-=folds                " do not store folds

" ########## visual options ##########
set wildmenu             " When 'wildmenu' is on, command-line completion operates in an enhanced mode.
set wildcharm=<C-Z>      " Shortcut to open the wildmenu when you are in the command mode - it's similar to <C-D>
set showmode             " If in Insert, Replace or Visual mode put a message on the last line.
set guifont=Monospace\ 8 " guifont + fontsize
set guicursor=a:blinkon0 " cursor-blinking off!!
set ruler                " show the cursor position all the time
set nowrap               " kein Zeilenumbruch
set foldmethod=indent    " Standardfaltungsmethode
set foldlevel=99         " default fold level
set winminheight=0       " Minimal Windowheight
set showcmd              " Show (partial) command in status line.
set showmatch            " Show matching brackets.
set matchtime=2          " time to show the matching bracket
set hlsearch             " highlight search
set linebreak            " If on Vim will wrap long lines at a character in 'breakat'
"set showbreak=>>\        " identifier put in front of wrapped lines
set lazyredraw           " no readraw when running macros
set scrolloff=3          " set X lines to the curors - when moving vertical..
set laststatus=2         " statusline is always visible
set statusline=(%{bufnr('%')})\ %t\ \ %r%m\ #%{expand('#:t')}\ (%{bufnr('#')})%=[%{&fileformat}:%{&fileencoding}:%{&filetype}]\ %l,%c\ %P " statusline
"set mouse=n             " mouse only in normal mode support in vim
"set foldcolumn=1        " show folds
set number               " draw linenumbers
set nolist               " list nonprintable characters
set sidescroll=0         " scroll X columns to the side instead of centering the cursor on another screen
set completeopt=menuone  " show the complete menu even if there is just one entry
set listchars+=precedes:<,extends:> " display the following nonprintable characters
if $LANG =~ ".*\.UTF-8$" || $LANG =~ ".*utf8$" || $LANG =~ ".*utf-8$"
	set listchars+=tab:»·,trail:·" display the following nonprintable characters
endif
set guioptions=aegitcm   " disabled menu in gui mode
"set guioptions=aegimrLtT
set cpoptions=aABceFsq$  " q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
" $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
" v: Backspaced characters remain visible on the screen in Insert mode.

colorscheme peaksea " default color scheme

" default color scheme
" if &term == '' || &term == 'builtin_gui' || &term == 'dumb'
if has('gui_running')
	set background=light " use colors that fit to a light background
	"set background=dark " use colors that fit to a dark background
else
	set background=light " use colors that fit to a light background
	"set background=dark " use colors that fit to a dark background
endif

syntax on " syntax highlighting

" ########## text options ##########
set smartindent              " always set smartindenting on
set autoindent               " always set autoindenting on
set copyindent               " always set copyindenting on
set backspace=2              " Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
set textwidth=0              " Don't wrap words by default
set shiftwidth=4             " number of spaces to use for each step of indent
set tabstop=4                " number of spaces a tab counts for
set noexpandtab              " insert spaces instead of tab
set smarttab                 " insert spaces only at the beginning of the line
set ignorecase               " Do case insensitive matching
set smartcase                " overwrite ignorecase if pattern contains uppercase characters
set formatoptions=lcrqn      " no automatic linebreak
set pastetoggle=<F11>        " put vim in pastemode - usefull for pasting in console-mode
set fileformats=unix,dos,mac " favorite fileformats
set encoding=utf-8           " set default-encoding to utf-8
set iskeyword+=_,-           " these characters also belong to a word
"set matchpairs+=<:>          " angle brackets should also being matched by %

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Special Configuration ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" ########## determine terminal encoding ##########
"if has("multi_byte") && &term != 'builtin_gui'
"    set termencoding=utf-8
"
"    " unfortunately the normal xterm supports only latin1
"    if $TERM == "xterm" || $TERM == "xterm-color" || $TERM == "screen" || $TERM == "linux" || $TERM_PROGRAM == "GLterm"
"        let propv = system("xprop -id $WINDOWID -f WM_LOCALE_NAME 8s ' $0' -notype WM_LOCALE_NAME")
"        if propv !~ "WM_LOCALE_NAME .*UTF.*8"
"            set termencoding=latin1
"        endif
"    endif
"    " for the possibility of using a terminal to input and read chinese
"    " characters
"    if $LANG == "zh_CN.GB2312"
"        set termencoding=euc-cn
"    endif
"endif

" Set paper size from /etc/papersize if available (Debian-specific)
if filereadable('/etc/papersize')
	let s:papersize = matchstr(system('/bin/cat /etc/papersize'), '\p*')
	if strlen(s:papersize)
		let &printoptions = "paper:" . s:papersize
	endif
	unlet! s:papersize
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Autocommands ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin on " automatically load filetypeplugins
filetype indent on " indent according to the filetype

if !exists("autocommands_loaded")
	let autocommands_loaded = 1

	augroup templates
		" read templates
		" au BufNewFile ?akefile,*.mk TSkeletonSetup Makefile
		" au BufNewFile *.tex TSkeletonSetup latex.tex
		" au BufNewFile build*.xml TSkeletonSetup antbuild.xml
		" au BufNewFile test*.py,*Test.py TSkeletonSetup pyunit.py
		" au BufNewFile *.py TSkeletonSetup python.py
	augroup END

	augroup filetypesettings
		" Do word completion automatically
		au FileType debchangelog setl expandtab
		au FileType asciidoc,mkd,txt,mail call DoFastWordComplete()
		au FileType tex,plaintex setlocal makeprg=pdflatex\ \"%:p\"
		"au FileType mkd setlocal autoindent
		au FileType java,c,cpp setlocal noexpandtab nosmarttab
		au FileType mail setlocal textwidth=70
		au FileType mail call FormatMail()
		au FileType mail setlocal formatoptions=tcrqan
		au FileType mail setlocal comments+=b:--
		au FileType txt setlocal formatoptions=tcrqn textwidth=72
		au FileType asciidoc,mkd,tex setlocal formatoptions=tcrq textwidth=72
		au FileType xml,docbk,xhtml,jsp setlocal formatoptions=tcrqn
		au FileType ruby setlocal shiftwidth=2

		au BufReadPost,BufNewFile *		set formatoptions-=o " o is really annoying
		au BufReadPost,BufNewFile *		call ReadIncludePath()

		" Special Makefilehandling
		au FileType automake,make setlocal list noexpandtab

		au FileType xsl,xslt,xml,html,xhtml runtime! scripts/closetag.vim

		" Omni completion settings
		"au FileType c		setlocal completefunc=ccomplete#Complete
		au FileType css setlocal omnifunc=csscomplete#CompleteCSS
		"au FileType html setlocal completefunc=htmlcomplete#CompleteTags
		"au FileType js setlocal completefunc=javascriptcomplete#CompleteJS
		"au FileType php setlocal completefunc=phpcomplete#CompletePHP
		"au FileType python setlocal completefunc=pythoncomplete#Complete
		"au FileType ruby setlocal completefunc=rubycomplete#Complete
		"au FileType sql setlocal completefunc=sqlcomplete#Complete
		"au FileType *		setlocal completefunc=syntaxcomplete#Complete
		"au FileType xml setlocal completefunc=xmlcomplete#CompleteTags

		au FileType help setlocal nolist

		" insert a prompt for every changed file in the commit message
		"au FileType svn :1![ -f "%" ] && awk '/^[MDA]/ { print $2 ":\n - " }' %
	augroup END

	augroup hooks
		" replace "Last Modified: with the current time"
		au BufWritePre,FileWritePre *	call LastMod()

		" line highlighting in insert mode
		autocmd InsertLeave *	set nocul
		autocmd InsertEnter *	set cul

		" move to the directory of the edited file
		"au BufEnter *      if isdirectory (expand ('%:p:h')) | cd %:p:h | endif

		" jump to last position in the file
		au BufRead *		if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "mail" | exe "normal g`\"" | endif
		" jump to last position every time a buffer is entered
		"au BufEnter *		if line("'x") > 0 && line("'x") <= line("$") && line("'y") > 0 && line("'y") <= line("$") && &filetype != "mail" | exe "normal g'yztg`x" | endif
		"au BufLeave *		if &modifiable | exec "normal mxHmy"
	augroup END

	augroup highlight
		" make visual mode dark cyan
		au FileType *	hi Visual ctermfg=Black ctermbg=DarkCyan gui=bold guibg=#a6caf0
		" make cursor red
		au BufEnter,BufRead,WinEnter *	:call SetCursorColor()

		" hightlight trailing spaces and tabs and the defined print margin
		"au FileType *	hi WhiteSpaceEOL_Printmargin ctermfg=black ctermbg=White guifg=Black guibg=White
		au FileType *	hi WhiteSpaceEOL_Printmargin ctermbg=Yellow guibg=Yellow
		au FileType *	let m='' | if &textwidth > 0 | let m='\|\%' . &textwidth . 'v.' | endif | exec 'match WhiteSpaceEOL_Printmargin /\s\+$' . m .'/'
	augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Functions ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" set cursor color
function! SetCursorColor()
	hi Cursor ctermfg=black ctermbg=red guifg=Black guibg=Red
endfunction
call SetCursorColor()

" change dir the root of a debian package
function! GetPackageRoot()
	let sd = getcwd()
	let owd = sd
	let cwd = owd
	let dest = sd
	while !isdirectory('debian')
		lcd ..
		let owd = cwd
		let cwd = getcwd()
		if cwd == owd
			break
		endif
	endwhile
	if cwd != sd && isdirectory('debian')
		let dest = cwd
	endif
	return dest
endfunction

" vim tip: Opening multiple files from a single command-line
function! Sp(dir, ...)
	let split = 'sp'
	if a:dir == '1'
		let split = 'vsp'
	endif
	if(a:0 == 0)
		execute split
	else
		let i = a:0
		while(i > 0)
			execute 'let files = glob (a:' . i . ')'
			for f in split (files, "\n")
				execute split . ' ' . f
			endfor
			let i = i - 1
		endwhile
		windo if expand('%') == '' | q | endif
	endif
endfunction
com! -nargs=* -complete=file Sp call Sp(0, <f-args>)
com! -nargs=* -complete=file Vsp call Sp(1, <f-args>)

" reads the file .include_path - useful for C programming
function! ReadIncludePath()
	let include_path = expand("%:p:h") . '/.include_path'
	if filereadable(include_path)
		for line in readfile(include_path, '')
			exec "setl path +=," . line
		endfor
	endif
endfunction

" update last modified line in file
fun! LastMod()
	let line = line(".")
	let column = col(".")
	let search = @/

	" replace Last Modified in the first 20 lines
	if line("$") > 20
		let l = 20
	else
		let l = line("$")
	endif
	" replace only if the buffer was modified
	if &mod == 1
		silent exe "1," . l . "g/Last Modified:/s/Last Modified:.*/Last Modified: " .
					\ strftime("%a %d. %b %Y %T %z %Z") . "/"
	endif
	let @/ = search

	" set cursor to last position before substitution
	call cursor(line, column)
endfun

" toggles show marks plugin
"fun! ToggleShowMarks()
"	if exists('b:sm') && b:sm == 1
"		let b:sm=0
"		NoShowMarks
"		setl updatetime=4000
"	else
"		let b:sm=1
"		setl updatetime=200
"		DoShowMarks
"	endif
"endfun

" reformats an email
fun! FormatMail()
	" workaround for the annoying mutt send-hook behavoir
	silent! 1,/^$/g/^X-To: .*/exec 'normal gg'|exec '/^To: /,/^Cc: /-1d'|1,/^$/s/^X-To: /To: /|exec 'normal dd'|exec '?Cc'|normal P
	silent! 1,/^$/g/^X-Cc: .*/exec 'normal gg'|exec '/^Cc: /,/^Bcc: /-1d'|1,/^$/s/^X-Cc: /Cc: /|exec 'normal dd'|exec '?Bcc'|normal P
	silent! 1,/^$/g/^X-Bcc: .*/exec 'normal gg'|exec '/^Bcc: /,/^Subject: /-1d'|1,/^$/s/^X-Bcc: /Bcc: /|exec 'normal dd'|exec '?Subject'|normal P

	" delete signature
	silent! /^> --[\t ]*$/,/^-- $/-2d
	" fix quotation
	silent! /^\(On\|In\) .*$/,/^-- $/-1:s/>>/> >/g
	silent! /^\(On\|In\) .*$/,/^-- $/-1:s/>\([^\ \t]\)/> \1/g
	" delete inner and trailing spaces
	normal :%s/[\xa0\x0d\t ]\+$//g
	normal :%s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g
	" format text
	normal gg
	" convert bad formated umlauts to real characters
	normal :%s/\\\([0-9]*\)/\=nr2char(submatch(1))/g
	normal :%s/&#\([0-9]*\);/\=nr2char(submatch(1))/g
	" break undo sequence
	normal iu
	exec 'silent! /\(^\(On\|In\) .*$\|\(schrieb\|wrote\):$\)/,/^-- $/-1!par '.&tw.'gqs0'
	" place the cursor before my signature
	silent! /^-- $/-1
	" clear search buffer
	let @/ = ""
endfun

" insert selection at mark a
fun! Insert() range
	exe "normal vgvmzomy\<Esc>"
	normal `y
	let lineA = line(".")
	let columnA = col(".")

	normal `z
	let lineB = line(".")
	let columnB = col(".")

	" exchange marks
	if lineA > lineB || lineA <= lineB && columnA > columnB
		" save z in c
		normal mc
		" store y in z
		normal `ymz
		" set y to old z
		normal `cmy
	endif

	exe "normal! gvd`ap`y"
endfun

" search with the selection of the visual mode
fun! VisualSearch(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
	if a:direction == '#'
		execute "normal! ?" . l:pattern . "^M"
	elseif a:direction == '*'
		execute "normal! /" . l:pattern . "^M"
	elseif a:direction == '/'
		execute "normal! /" . l:pattern
	else
		execute "normal! ?" . l:pattern
	endif
	let @/ = l:pattern
	let @" = l:saved_reg
endfun

" 'Expandvar' expands the variable under the cursor
fun! <SID>Expandvar()
	let origreg = @"
	normal yiW
	if (@" == "@\"")
		let @" = origreg
	else
		let @" = eval(@")
	endif
	normal diW"0p
	let @" = origreg
endfun

" execute the bc calculator
fun! <SID>Bc(exp)
	setlocal paste
	normal mao
	exe ":.!echo 'scale=2; " . a:exp . "' | bc"
	normal 0i "bDdd`a"bp
	setlocal nopaste
endfun

fun! <SID>RFC(number)
	silent exe ":e http://www.ietf.org/rfc/rfc" . a:number . ".txt"
endfun

" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile
	return r
endfunc

" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
	let out = ''
	let ix = 0
	while ix < strlen(a:str)
		let out = out . Nr2Hex(char2nr(a:str[ix]))
		let ix = ix + 1
	endwhile
	return out
endfunc

" translates hex value to the corresponding number
fun! Hex2Nr(hex)
	let r = 0
	let ix = strlen(a:hex) - 1
	while ix >= 0
		let val = 0
		if a:hex[ix] == '1'
			let val = 1
		elseif a:hex[ix] == '2'
			let val = 2
		elseif a:hex[ix] == '3'
			let val = 3
		elseif a:hex[ix] == '4'
			let val = 4
		elseif a:hex[ix] == '5'
			let val = 5
		elseif a:hex[ix] == '6'
			let val = 6
		elseif a:hex[ix] == '7'
			let val = 7
		elseif a:hex[ix] == '8'
			let val = 8
		elseif a:hex[ix] == '9'
			let val = 9
		elseif a:hex[ix] == 'a' || a:hex[ix] == 'A'
			let val = 10
		elseif a:hex[ix] == 'b' || a:hex[ix] == 'B'
			let val = 11
		elseif a:hex[ix] == 'c' || a:hex[ix] == 'C'
			let val = 12
		elseif a:hex[ix] == 'd' || a:hex[ix] == 'D'
			let val = 13
		elseif a:hex[ix] == 'e' || a:hex[ix] == 'E'
			let val = 14
		elseif a:hex[ix] == 'f' || a:hex[ix] == 'F'
			let val = 15
		endif
		let r = r + val * Power(16, strlen(a:hex) - ix - 1)
		let ix = ix - 1
	endwhile
	return r
endfun

" mathematical power function
fun! Power(base, exp)
	let r = 1
	let exp = a:exp
	while exp > 0
		let r = r * a:base
		let exp = exp - 1
	endwhile
	return r
endfun

" Captialize movent/selection
function! Capitalize(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use '< and '> marks.
	silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
	silent exe "normal! '[V']y"
  elseif a:type == 'block'
	silent exe "normal! `[\<C-V>`]y"
  else
	silent exe "normal! `[v`]y"
  endif

  silent exe "normal! `[gu`]~`]"

  let &selection = sel_save
  let @@ = reg_save
endfunction

" Find file in current directory and edit it.
function! Find(...)
  let path="."
  if a:0==2
    let path=a:2
  endif
  let l:list=system("find ".path. " -name '".a:1."' | grep -v .svn ")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:1."' not found"
    return
  endif
  if l:num != 1
    let tmpfile = tempname()
    exe "redir! > " . tmpfile
    silent echon l:list
    redir END
    let old_efm = &efm
    set efm=%f

    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif

    let &efm = old_efm

    " Open the quickfix window below the current window
    botright copen

    call delete(tmpfile)
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Plugin Settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Do not go to active window.
"let g:bufExplorerFindActive = 0
" Don't show directories.
"let g:bufExplorerShowDirectories = 0
" Sort by full file path name.
"let g:bufExplorerSortBy = 'fullpath'
" Show relative paths.
"let g:bufExplorerShowRelativePath = 1

" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" load manpage-plugin
runtime! ftplugin/man.vim

" load matchit-plugin
runtime! macros/matchit.vim

" minibuf explorer
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplorerMoreThanOne = 0
"let g:miniBufExplModSelTarget = 0
"let g:miniBufExplUseSingleClick = 1
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplVSplit = 25
"let g:miniBufExplSplitBelow = 1
"let g:miniBufExplForceSyntaxEnable = 1
"let g:miniBufExplTabWrap = 1

" calendar plugin
" let g:calendar_weeknm = 4

" xml-ftplugin configuration
let xml_use_xhtml = 1

" :ToHTML
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" LatexSuite
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_Diacritics = 1

" python-highlightings
let python_highlight_all = 1

" Eclim settings
"let org.eclim.user.name     = g:tskelUserName
"let org.eclim.user.email    = g:tskelUserEmail
"let g:EclimLogLevel         = 4 " info
"let g:EclimBrowser          = "x-www-browser"
"let g:EclimShowCurrentError = 1
" nnoremap <silent> <buffer> <tab> :call eclim#util#FillTemplate("${", "}")<CR>
" nnoremap <silent> <buffer> <leader>i :JavaImport<CR>
" nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<CR>
" nnoremap <silent> <buffer> <CR> :JavaSearchContext<CR>
" nnoremap <silent> <buffer> <CR> :AntDoc<CR>

" quickfix notes plugin
map <Leader>n <Plug>QuickFixNote
nnoremap <F6> :QFNSave ~/.vimquickfix/
nnoremap <S-F6> :e ~/.vimquickfix/
nnoremap <F7> :cgetfile ~/.vimquickfix/
nnoremap <S-F7> :caddfile ~/.vimquickfix/
nnoremap <S-F8> :!rm ~/.vimquickfix/

" EnhancedCommentify updated keybindings
"vmap <Leader><Space> <Plug>VisualTraditional
"nmap <Leader><Space> <Plug>Traditional
"let g:EnhCommentifyTraditionalMode = 'No'
"let g:EnhCommentifyPretty = 'No'
"let g:EnhCommentifyRespectIndent = 'Yes'

" FuzzyFinder keybinding
nnoremap <leader>fb :FufBuffer<CR>
nnoremap <leader>fd :FufDir<CR>
nnoremap <leader>fD :FufDir <C-r>=expand('%:~:.:h').'/'<CR><CR>
nmap <leader>Fd <leader>fD
nmap <leader>FD <leader>fD
nnoremap <leader>ff :FufFile<CR>
nnoremap <leader>fF :FufFile <C-r>=expand('%:~:.:h').'/'<CR><CR>
nmap <leader>FF <leader>fF
nnoremap <leader>ft :FufTextMate<CR>
nnoremap <leader>fr :FufRenewCache<CR>
let g:fuf_modesDisable = [ 'bookmark', 'tag', 'taggedfile', 'quickfix', 'mrufile', 'mrucmd', 'buffer' ]
let g:fuf_onelinebuf_location  = 'botright'
let g:fuf_maxMenuWidth = 300
let g:fuf_file_exclude = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight = 0

" YankRing
nnoremap <silent> <F8> :YRShow<CR>
let g:yankring_history_file = '.yankring_history_file'
"let g:yankring_replace_n_pkey = '<c-\>'
"let g:yankring_replace_n_nkey = '<c-m>'

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" TagList
let Tlist_Show_One_File = 1

" UltiSnips
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"

" NERD Commenter
nmap <leader><space> <plug>NERDCommenterToggle
vmap <leader><space> <plug>NERDCommenterToggle
imap <C-c> <ESC>:call NERDComment(0, "insert")<CR>

" disable unused Mark mappings
nmap <leader>_r <plug>MarkRegex
vmap <leader>_r <plug>MarkRegex
nmap <leader>_n <plug>MarkClear
vmap <leader>_n <plug>MarkClear
nmap <leader>_* <plug>MarkSearchCurrentNext
nmap <leader>_# <plug>MarkSearchCurrentPrev
nmap <leader>_/ <plug>MarkSearchAnyNext
nmap <leader>_# <plug>MarkSearchAnyPrev
nmap <leader>__* <plug>MarkSearchNext
nmap <leader>__# <plug>MarkSearchPrev

" Nerd Tree explorer mapping
nmap <leader>e :NERDTreeToggle<CR>

" TaskList settings
let g:tlWindowPosition = 1

" delimitMate
"let delimitMate = "[:],(:),{:},<:>"
let delimitMate_quotes = ""
let delimitMate_apostrophes = ""

" DumpBuf settings
let g:dumbbuf_hotkey = '<Leader>b'

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Keymappings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" edit/reload .vimrc-Configuration
nnoremap gce :e $HOME/.vimrc<CR>
nnoremap gcl :source $HOME/.vimrc<CR>:echo "Configuration reloaded"<CR>

" un/hightlight current line
nnoremap <silent> <Leader>H :match<CR>
nnoremap <silent> <Leader>h mk:exe 'match Search /<Bslash>%'.line(".").'l/'<CR>

" spellcheck off, german, englisch
nnoremap gsg :setlocal invspell spelllang=de<CR>
nnoremap gse :setlocal invspell spelllang=en<CR>

" switch to previous/next buffer
"nnoremap <silent> <c-p> :bprevious<CR>
"nnoremap <silent> <c-n> :bnext<CR>

" kill/delete trailing spaces and tabs
nnoremap <Leader>kt msHmt:silent! %s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing spaces"<CR>'tzt`s
vnoremap <Leader>kt :s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing, spaces"<CR>

" kill/reduce inner spaces and tabs to a single space/tab
nnoremap <Leader>ki msHmt:silent! %s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>'tzt`s
vnoremap <Leader>ki :s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>

" start new undo sequences when using certain commands in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
if has('gui_running')
	inoremap <C-H> <C-G>u<C-H>
endif
inoremap <Del> <C-G>u<Del>

" swap two words
" http://www.vim.org/tips/tip.php?tip_id=329
nmap <silent> gw "_yiw:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>
nmap <silent> gW "_yiW:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>

" Capitalize movement
nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
vnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>

" delete search-register
nnoremap <silent> <leader>/ :let @/ = ""<CR>

" browse current buffer/selection in www-browser
"nnoremap <Leader>b :!x-www-browser %:p<CR>:echo "WWW-Browser started"<CR>
"vnoremap <Leader>b y:!x-www-browser <C-R>"<CR>:echo "WWW-Browser started"<CR>

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <Leader>T mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
"nnoremap <Leader>t mayiw`a:exe "!dict -P - -- " . @"<CR>
" vnoremap <Leader>T may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
"vnoremap <Leader>t may`a:exe "!dict -P - -- " . @"<CR>

" delete words in insert and command mode like expected - doesn't work properly
" at the end of the line
inoremap <C-BS> <C-w>
cnoremap <C-BS> <C-w>
if !has('gui_running')
	cnoremap <C-H> <C-w>
	inoremap <C-H> <C-w>
endif

" Switch buffers
nnoremap <silent> [b :ls<Bar>let nr = input("Buffer: ")<Bar>if nr != ''<Bar>exe ":b " . nr<Bar>endif<CR>
" Search for the occurence of the word under the cursor
nnoremap <silent> [I [I:let nr = input("Item: ")<Bar>if nr != ''<Bar>exe "normal " . nr ."[\t"<Bar>endif<CR>

" copy/paste clipboard
nnoremap gp "+p
vnoremap gy "+y
" actually gY is not that useful because the visual mode will do the same
vnoremap gY "*y
nnoremap gP "*p

" replace within the visual selection
vnoremap gvs :<BS><BS><BS><BS><BS>%s/\%V

" delete buffer without closing the window
nnoremap <Leader>d :Kwbd<CR>

" shortcut for q-register playback
" nnoremap Q @q

" opens input for mathematical expressions
nnoremap <Leader>= :Bc<Space>

" edit files even if they do not exist
nnoremap gcf :e <cfile><CR>

" edit files in PATH environment variable
nnoremap gxf :exec ':e '.system('which '.expand("<cfile>"))<CR>

" save current file
inoremap <F2> <Esc>:w<CR>a
inoremap <S-F2> <Esc>:w!<CR>a
nnoremap <F2> :w<CR>
nnoremap <S-F2> :w!<CR>

" store, load and delete vimessions
nnoremap <F3> :mksession! ~/.vimsessions/
nnoremap <F4> :source ~/.vimsessions/
nnoremap <F5> :!rm ~/.vimsessions/

" Make window mappings a bit easier to type
"map <leader><leader> <c-w>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" open quickfix list
nmap <F9> :copen<CR>

" show menu
nmap <F10> :emenu <C-Z>
imap <F10> <C-O>:emenu <C-Z>

" insert times easily
imap ,t <C-R>=strftime('%H:%M')<CR>
imap ,d <C-R>=strftime('%Y-%m-%d')<CR>
imap ,r <ESC>:language time C<CR>a<C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>

" shortcut to open vim help
nnoremap <leader>v :exe 'h '.expand("<cword>")<CR>
vnoremap <leader>v "zy:h <C-R>z<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- changes to the default behavior ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" fast quit without save
nnoremap <silent> ZQ :qa!<CR>

" fast quit with save
nnoremap <silent> ZZ :wa<CR>:qa<CR>

" visual search
vnoremap <silent> * :call VisualSearch('*')<CR>
vnoremap <silent> # :call VisualSearch('#')<CR>
" change default behavior to not start the search immediately
" have a look at :h restore-position
nnoremap <silent> * ms"zyiwHmt/\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>
nnoremap <silent> # ms"zyiwHmt?\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>

" always move cursor on displayed lines
"map j gj
"map k gk

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Commands ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Easy jumping between files with failed patches
" Reject
command! R :if expand ('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.rej'|else|execute 'e %.rej'|endif
" Orig
command! O :if expand ('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.orig'|else|execute 'e %.orig'|endif
" Mine
command! M :if expand ('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.mine'|else|execute 'e %.mine'|endif
" Current
command! C :if expand ('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r'|else|execute 'e %'|endif

" Wrap on and textwidth zero
command! WT :setl wrap|setl tw=0
command! NOWT :setl nowrap|setl tw=80

" 'Kwbd' deletes buffer without closing the window
command! Kwbd enew|bw #|bn|bw #
" spawn terminal in current working directory
command! Sh :silent !setsid x-terminal-emulator
" spawn terminal in the directory of the currently edited buffer
command! SH :silent lcd %:p:h|exec "silent !setsid x-terminal-emulator"|silent lcd -
" change to directory of the current buffer
command! Lcd :lcd %:p:h
command! Cd :cd %:p:h
command! CD :Cd
command! LCD :Lcd
command! Cddeb :exec "lcd ".GetPackageRoot()
command! Padddeb :exec "set path+=".GetPackageRoot()
command! Psubdeb :exec "set path-=".GetPackageRoot()
command! Padd :exec "set path+=".expand("%:p:h")
command! Psub :exec "set path-=".expand("%:p:h")

" 'Bc' computes the given expressin
command! -nargs=1 Bc call <SID>Bc(<q-args>)

" 'PW' generates a password of twelve characters
command! PW :.!tr -cd "[a-zA-Z0-9]" < /dev/urandom | head -c 12

" 'RFC number' opens the corresponding rfc
command! -nargs=1 RFC call <SID>RFC(<q-args>)

" 'Expandvar' expands the variable under the cursor
command! -nargs=0 EXpandvar call <SID>Expandvar()

" Shortcut to reload UltiSnips Manager
"command! ResetUltiSnips :py UltiSnips_Manager.reset()

" Find files
command! -nargs=* Find :call Find(<f-args>)

" Make current file executeable
command! -nargs=0 Chmodx :!chmod +x %

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- personal settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" source other personal settings
runtime! personal.vim
