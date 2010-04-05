" Author: Jan Christoph Ebersbach jceb AT e-jc DOT de

" ToC - use UTL to jump to the entries
" <url:#r=Settings>
" <url:#r=Special Configuration>
" <url:#r=Autocommands>
" <url:#r=Highlighting and Colors>
" <url:#r=Functions>
" <url:#r=Plugin Settings>
" <url:#r=Keymappings>
" <url:#r=Changes to the default behavior>
" <url:#r=Commands>
" <url:#r=Personal settings>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Settings ----------
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
set history=100                " keep 100 lines of command line history
set incsearch                  " Incremental search
set hidden                     " hidden allows to have modified buffers in background
set noswapfile                 " turn off backups and files
set nobackup                   " Don't keep a backup file
set magic                      " special characters that can be used in search patterns
set grepprg=grep\ --exclude='*.svn-base'\ -n\ $*\ /dev/null " don't grep through svn-base files
" Try do use the ack program when available
let tmp = ''
for i in ['ack-grep', 'ack']
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
set switchbuf=usetab           " This option controls the behavior when switching between buffers.
set printoptions=paper:a4,syntax:n " controls the default paper size and the printing of syntax highlighting (:n -> none)

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
	set listchars+=tab:»·,trail:·,precedes:…,extends:…
else
	set listchars=tab:>-,trail:-
endif
set guioptions=aegitcm   " disabled menu in gui mode
"set guioptions=aegimrLtT
set cpoptions=aABceFsq  " q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
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
set virtualedit=onemore      " allow the cursor to move beyond the last character of a line
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
" ---------- id=Special Configuration ----------
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
" ---------- id=Autocommands ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin on " automatically load filetypeplugins
filetype indent on " indent according to the filetype

augroup filetypesettings
	autocmd!
	" Do word completion automatically
	au FileType debchangelog setl expandtab
	au FileType tex,plaintex setlocal makeprg=pdflatex\ \"%:p\"
	"au FileType mkd setlocal autoindent
	au FileType java,c,cpp setlocal noexpandtab nosmarttab
	au FileType mail setlocal textwidth=72 formatoptions=tcrqan comments+=b:--
	au FileType mail call FormatMail()
	au FileType txt setlocal formatoptions=tcrqn textwidth=72
	au FileType asciidoc,mkd,tex setlocal formatoptions=tcrq textwidth=72
	au FileType xml,docbk,xhtml,jsp setlocal formatoptions=tcrqn
	au FileType ruby setlocal shiftwidth=2

	au BufReadPost,BufNewFile *		set formatoptions-=o " o is really annoying
	au BufReadPost,BufNewFile *		call <SID>ReadIncludePath()
	au BufReadPost,BufNewFile *		call <SID>Tw(&tw)

	" Special Makefilehandling
	au FileType automake,make setlocal list noexpandtab

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
	autocmd!
	" replace "Last Modified: with the current time"
	au BufWritePre,FileWritePre *	:call LastMod()

	" line highlighting in insert mode
	autocmd InsertLeave *	set nocul
	autocmd InsertEnter *	set cul

	" move to the directory of the edited file
	"au BufEnter *      if isdirectory (expand ('%:p:h')) | cd %:p:h | endif

	" jump to last position in the file
	au BufReadPost *	if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 && line("'\"") > 1 && line("'\"") <= line("$") && &filetype != "mail" | exe "normal g`\"" | endif

	" jump to last position every time a buffer is entered
	"au BufEnter *		if line("'x") > 0 && line("'x") <= line("$") && line("'y") > 0 && line("'y") <= line("$") && &filetype != "mail" | exe "normal g'yztg`x" | endif
	"au BufLeave *		if &modifiable | exec "normal mxHmy"
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Highlighting and Colors ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""
" set cursor color
function! SetCursorColor()
	hi Cursor ctermfg=black ctermbg=red guifg=Black guibg=Red
	hi CursorLine term=underline cterm=underline gui=underline guifg=NONE guibg=NONE
endfunction

call SetCursorColor()

" highlight print margin
function! HighlightPrintmargin()
	hi Printmargin cterm=inverse gui=inverse
	let m=''
	if &textwidth > 0
		let m='\%' . &textwidth . 'v.'
		exec 'match Printmargin /' . m .'/'
	else
		match
	endif
endfunction

" highlight trailing spaces
function! HighlightTrailingSpace()
	hi TrailingSpace cterm=inverse gui=inverse
	syntax match TrailingSpace '\s\+$' display containedin=ALL
endfunction

augroup highlight
	autocmd!
	" make visual mode dark cyan
	au FileType *	hi Visual ctermfg=Black ctermbg=DarkCyan gui=bold guibg=#a6caf0

	" make cursor red
	au BufEnter,WinEnter *	:call SetCursorColor()

	" hightlight trailing spaces and tabs and the defined print margin
	au BufEnter,WinEnter *	match | if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 | call HighlightPrintmargin() | call HighlightTrailingSpace() | endif
augroup END

" un/highlight current line
nnoremap <silent> <Leader>H :match<CR>
nnoremap <silent> <Leader>h mk:exe 'match Search /<Bslash>%'.line(".").'l/'<CR>

" clear search register, useful if you want to get rid of too much highlighting
nnoremap <silent> <leader>/ :let @/ = ""<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Functions ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Get root directory of the debian package you are currently in
function! GetDebianPackageRoot()
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

" reads the file .include_path - useful for C programming
function! <SID>ReadIncludePath()
	let include_path = expand("%:p:h") . '/.include_path'
	if filereadable(include_path)
		for line in readfile(include_path, '')
			exec "setl path +=," . line
		endfor
	endif
endfunction

" Update line starting with "Last Modified:"
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

" search with the selection of the visual mode
fun! VisualSearch(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
	if a:direction == '#'
		"execute "normal! ?" . l:pattern . "^M"
		execute "normal! ?" . l:pattern
	elseif a:direction == '*'
		"execute "normal! /" . l:pattern . "^M"
		execute "normal! /" . l:pattern
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

fun! <SID>Tw(number)
	exe 'set tw=' . a:number
	call HighlightPrintmargin()
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

" Captialize word (movent/selection)
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

" Find files in current directory and load them into quickfix list
" Source: http://vim.wikia.com/wiki/Find_files_in_subdirectories
" @param	a:0	searchtype 'i'gnorecase or 'n'ormal
" @param	a:1	searchterm
" @param	a:2	path (optional)
function! Find(...)
	let searchtype = '-name'
	if a:1 == 'i'
		let searchtype = '-iname'
	endif
	let searchterm = a:2
	let path="."
	if a:0 == 3
		let path = a:3
	endif
	let l:list=system("find ".path." -not -wholename '*/.bzr*' -a -not -wholename '*/.hg*' -a -not -wholename '*/.git*' -a -not -wholename '*.svn*' -a -not -wholename '*/CVS*' -type f ".searchtype." '*".searchterm."*'")
	let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
	if l:num < 1
		echo "'".searchterm."' not found"
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

function! Create_directory(dir)
	if isdirectory(a:dir) != 0
		mkdir(a:dir)
	endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Plugin Settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" load manpage-plugin
runtime! ftplugin/man.vim

" load matchit-plugin
runtime! macros/matchit.vim

" txtbrowser
" ----------
" don't load the plugin cause it's not helpful for my workflow
" id=txtbrowser_disabled
let g:txtbrowser_version = "don't load!"

" fastwordcompleter
" -----------------
let g:fastwordcompleter_filetypes = 'asciidoc,mkd,txt,mail,help'

" netrw
" -----
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" bufexplorer
" -----------
" Do not go to active window.
"let g:bufExplorerFindActive = 0
" Don't show directories.
"let g:bufExplorerShowDirectories = 0
" Sort by full file path name.
"let g:bufExplorerSortBy = 'fullpath'
" Show relative paths.
"let g:bufExplorerShowRelativePath = 1

" GetLatestVimScripts
" -------------------
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" minibuf explorer
" ----------------
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
" ---------------
" let g:calendar_weeknm = 4

" xml-ftplugin configuration
" --------------------------
let xml_use_xhtml = 1

" :ToHTML
" -------
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" LatexSuite
" ----------
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_Diacritics = 1

" python-highlightings
" --------------------
let python_highlight_all = 1

" Eclim settings
" --------------
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

" Quickfix notes
" --------------
map <Leader>n <Plug>QuickFixNote

" FuzzyFinder
" -----------
" expand the current filenames directory or use the current working directory
function! Expand_filedirectory()
	let dir = expand('%:~:.:h')
	if dir == ''
		let dir = getcwd()
	endif
	let dir .= '/'
	return dir
endfunction

nnoremap <leader>fh :FufHelp<CR>
"nnoremap <leader>fb :FufBuffer<CR>
nnoremap <leader>fd :FufDir<CR>
nnoremap <leader>fD :FufDir <C-r>=Expand_filedirectory()<CR><CR>
nmap <leader>Fd <leader>fD
nmap <leader>FD <leader>fD
nnoremap <leader>ff :FufFile<CR>
nnoremap <leader>fF :FufFile <C-r>=Expand_filedirectory()<CR><CR>
nmap <leader>FF <leader>fF
""nnoremap <leader>ft :FufTextMate<CR>
"nnoremap <leader>fr :FufRenewCache<CR>
let g:fuf_modesDisable = [ 'bookmark', 'tag', 'taggedfile', 'quickfix', 'mrufile', 'mrucmd', 'buffer', 'jumplist', 'changelist', 'line' ]
let g:fuf_onelinebuf_location  = 'botright'
let g:fuf_maxMenuWidth = 300
let g:fuf_file_exclude = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight = 0

" YankRing
" --------
nnoremap <silent> <F8> :YRShow<CR>
let g:yankring_history_file = '.yankring_history_file'
let g:yankring_map_dot = 0

" Supertab
" --------
let g:SuperTabDefaultCompletionType = "<c-n>"

" TagList
" -------
let Tlist_Show_One_File = 1

" UltiSnips
" ---------
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"

" NERD Commenter
" --------------
nmap <leader><space> <plug>NERDCommenterToggle
vmap <leader><space> <plug>NERDCommenterToggle
imap <C-c> <ESC>:call NERDComment(0, "insert")<CR>

" disable unused Mark mappings
" ----------------------------
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
" -----------------
let g:tlWindowPosition = 1

" delimitMate
" -----------
"let g:delimitMate_matchpairs = "[:],(:),{:},<:>" " braces that shall be closed autoamtically
"let g:delimitMate_quotes = ""
"let g:delimitMate_apostrophes = ""

" DumpBuf settings
" ----------------
let g:dumbbuf_hotkey = '<Leader>b'

" Universal Text Linking
" ----------------------
if $DISPLAY != "" || has('gui_running')
	let g:utl_cfg_hdl_scm_http = "silent !x-www-browser '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !x-terminal-emulator -e mutt '%u'"
	let g:utl_cfg_hdl_mt_application_pdf = 'silent !kpdf "%p"'
else
	let g:utl_cfg_hdl_scm_http = "silent !www-browser '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !mutt '%u'"
	let g:utl_cfg_hdl_mt_application_pdf = 'new|set buftype=nofile|.!pdftotext "%p" -'
endif

" Shortcut to run the Utl command
" open link
nnoremap gl :Utl<CR>
vnoremap gl :Utl o v<CR>
" copy linke
nnoremap gcc :Utl cl<CR>
vnoremap gcc :Utl cl v<CR>

" LustyExplorer
" -------------
nnoremap ,b :LustyBufferExplorer<CR>
nnoremap ,f :LustyFilesystemExplorer<CR>
nnoremap ,F :LustyFilesystemExplorerFromHere<CR>

" showmarks
" ---------
" showmarks number of included marks
let g:showmarks_include="abcdefghijklmnopqrstuvwxyz'`"

" disable show marks if gui is not running
if !has('gui_running')
	let g:showmarks_enable = 0
endif

" don't use show marks on help, non-modifiable, preview and quickfix buffers
let g:showmarks_ignore_type="hmpq"

" highlight lines with lower case marks
"let g:showmarks_hlline_lower=1

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Keymappings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Jump behind the next closing brace and start editing
inoremap <C-j> <Esc>l%%a
nnoremap <C-j> %%

" delete buffer while keeping the window structure
nnoremap ,k :enew<CR>bw #<CR>bn<CR>bw #<CR>

" edit/reload .vimrc-Configuration
nnoremap ,e :e $HOME/.vimrc<CR>
nnoremap ,v :vs $HOME/.vimrc<CR>
nnoremap ,u :source $HOME/.vimrc<CR>:echo "Configuration reloaded"<CR>

" spellcheck off, german, englisch
nnoremap gsg :setlocal invspell spelllang=de<CR>
nnoremap gse :setlocal invspell spelllang=en<CR>

" kill/delete trailing spaces and tabs
nnoremap <Leader>kt msHmt:silent! g!/^-- $/s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing spaces"<CR>'tzt`s
vnoremap <Leader>kt :s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing, spaces"<CR>

" kill/reduce inner spaces and tabs to a single space/tab
nnoremap <Leader>ki msHmt:silent! %s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>'tzt`s
vnoremap <Leader>ki :s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>

" swap two words
" http://vim.wikia.com/wiki/VimTip47
nnoremap <silent> gw "_yiw:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>
nnoremap <silent> gW "_yiW:s/\(\%#[ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)\(\_W\+\)\([ÄÖÜäöüßa-zA-Z0-9-+*_]\+\)/\3\2\1/<CR><C-o><C-l>:let @/ = ""<CR>

" Capitalize words (movement)
nnoremap <silent> gC :set opfunc=Capitalize<CR>g@
vnoremap <silent> gC :<C-U>call Capitalize(visualmode(), 1)<CR>

" remove word delimiter from search term
function! Removed_word_delimiter()
	let tmp = substitute(substitute(@/, '^\\<', '', ''), '\\>$', '', '')
	execute "normal! /" . tmp
	let @/ = tmp
	unlet tmp
endfunction
nnoremap <silent> <leader>> :call Removed_word_delimiter()<CR>
nmap <silent> <leader>< <leader>>

" browse current buffer/selection in www-browser
"nnoremap <Leader>b :!x-www-browser %:p<CR>:echo "WWW-Browser started"<CR>
"vnoremap <Leader>b y:!x-www-browser <C-R>"<CR>:echo "WWW-Browser started"<CR>

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <Leader>T mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
"nnoremap <Leader>t mayiw`a:exe "!dict -P - -- " . @"<CR>
" vnoremap <Leader>T may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
"vnoremap <Leader>t may`a:exe "!dict -P - -- " . @"<CR>

" copy/paste to/from clipboard
nnoremap gp "+p
vnoremap gy "+y
" actually gY is not that useful because the visual mode will do the same
"vnoremap gY "*y
"nnoremap gP "*p

" replace within the visual selection
vnoremap gvs :<BS><BS><BS><BS><BS>%s/\%V

" opens input for mathematical expressions
nnoremap <Leader>= :Bc<Space>

" in addition to the gf and gF commands:
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
nnoremap <leader>sc :call Create_directory('~/.vimsessions')<CR>:mksession! ~/.vimsessions/
nnoremap <leader>sl :call Create_directory('~/.vimsessions')<CR>:source ~/.vimsessions/
nnoremap <leader>sd :call Create_directory('~/.vimsessions')<CR>:!rm ~/.vimsessions/

" store, load and delete quickfix information
nnoremap <leader>qc :call Create_directory('~/.vimquickfix')<CR>:QFNSave ~/.vimquickfix/
nnoremap <leader>ql :call Create_directory('~/.vimquickfix')<CR>set efm=%f:%l:%c:%m<CR>:cgetfile ~/.vimquickfix/
nnoremap <leader>qd :call Create_directory('~/.vimquickfix')<CR>:!rm ~/.vimquickfix/

" toggles the quickfix window.
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
"command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle()
	if exists("g:qfix_win")
		cclose
	else
		copen
	endif
endfunction

" used to track the quickfix window
augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
	autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

nnoremap <F9> :call QFixToggle()<CR>

" shortcut to open vim help
nnoremap <leader>v :exe 'h '.expand("<cword>")<CR>
vnoremap <leader>v "zy:h <C-R>z<CR>

" insert current filename similar, behavior similar to normal mode
cnoremap <C-g> <C-r>=expand('%:t')<CR>
" insert current filename with the whole path
cnoremap 1<C-g> <C-r>=expand('%:p')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Changes to the default behavior ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" disable <F1> mapping to open vim help
nmap <F1> :echo<CR>

" fast quit without save
nnoremap <silent> ZQ :qa!<CR>
nmap ,q ZQ

" fast quit with save
nnoremap <silent> ZZ :wa<CR>:qa<CR>

" visual search
vnoremap <silent> * :call VisualSearch('*')<CR>
vnoremap <silent> # :call VisualSearch('#')<CR>
" change default behavior to not start the search immediately
" have a look at :h restore-position
nnoremap <silent> * ms"zyiwHmt/\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>
nnoremap <silent> # ms"zyiwHmt?\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>

" start new undo sequences when using certain commands in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
if has('gui_running')
	inoremap <C-H> <C-G>u<C-H>
endif
inoremap <Del> <C-G>u<Del>

" delete words in insert and command mode like expected - doesn't work properly
" at the end of the line
inoremap <C-BS> <C-w>
cnoremap <C-BS> <C-w>
inoremap <C-Del> <C-o>dw
cnoremap <C-Del> <C-Right><C-w>
if !has('gui_running')
	cnoremap <C-H> <C-w>
	inoremap <C-H> <C-w>
endif

" Switch buffers. Better use ,b or <leader>b
"nnoremap <silent> [b :ls<Bar>let nr = input("Buffer: ")<Bar>if nr != ''<Bar>exe ":b " . nr<Bar>endif<CR>
" Search for the occurrence of the word under the cursor
nnoremap <silent> [I [I:let nr = input("Item: ")<Bar>if nr != ''<Bar>exe "normal " . nr ."[\t"<Bar>endif<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Commands ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Easy jumping between files with failed patches
" Reject
command! R :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.rej'|else|execute 'e %.rej'|endif
" Orig
command! O :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.orig'|else|execute 'e %.orig'|endif
" Mine
command! M :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r.mine'|else|execute 'e %.mine'|endif
" Source Code
command! S :if expand('%') =~ '\.\(mine\|orig\|rej\)$'|execute 'e %:r'|else|execute 'e %'|endif

" spawn terminal in current working directory
command! Sh :silent !setsid x-terminal-emulator
" spawn terminal in the directory of the currently edited buffer
command! SH :silent lcd %:p:h|exec "silent !setsid x-terminal-emulator"|silent lcd -

" change to directory of the current buffer
command! Lcd :lcd %:p:h
command! Cd :cd %:p:h
command! CD :Cd
command! LCD :Lcd
" chdir to directory with subdirector ./debian (very useful if you do
" Debian development)
command! Cddeb :exec "lcd ".GetDebianPackageRoot()

" add directories to the path variable which eases the use of gf and
" other commands operating on the path
command! PathAdddeb :exec "set path+=".GetDebianPackageRoot()
command! PathSubdeb :exec "set path-=".GetDebianPackageRoot()
command! PathAdd :exec "set path+=".expand("%:p:h")
command! PathSub :exec "set path-=".expand("%:p:h")

" create tags file in current working directory
command! MakeTags :silent !ctags -R *

" Let 'Bc' compute the given expression
command! -nargs=1 Bc call <SID>Bc(<q-args>)

" 'RFC number' open the requested RFC number in a new window
command! -nargs=1 RFC call <SID>RFC(<q-args>)

" 'Expandvar' expand the variable under the cursor
command! -nargs=0 Xpandvar call <SID>Expandvar()

" 'Tw' set the textwidth and update the printmarign highlighting in one step
command! -nargs=1 Tw call <SID>Tw(<q-args>)

" Shortcut to reload UltiSnips Manager
"command! ResetUltiSnips :py UltiSnips_Manager.reset()

" Find files
command! -nargs=* -complete=file Find :call Find('n', <f-args>)
command! -nargs=* -complete=file Findi :call Find('i', <f-args>)

" Make current file executeable
command! -nargs=0 Chmodx :!chmod +x %

" Improved versions of :sp and :vs which allow to open multiple files at once
command! -nargs=* -complete=file Sp call Sp(0, <f-args>)
command! -nargs=* -complete=file Vs call Sp(1, <f-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Personal settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" source other personal settings
runtime! personal.vim
