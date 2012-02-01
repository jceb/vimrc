" Global Settings:
" ----------------

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modeline
set modelines=5


" Miscellaneous Settings:
" -----------------------

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
for i in ['ack-grep', 'ack']
	let tmp = '/usr/bin/'.i
	if filereadable(tmp)
		exec "set grepprg=".tmp."\\ -a\\ -H\\ --nocolor\\ --nogroup"
	endif
	"let tmp = ""
	"try
	"	let tmp = substitute(system('which '.i), '\n.*', '', '')
	"catch
	"endtry
	"if v:shell_error == 0
	"	exec "set grepprg=".tmp."\\ -a\\ -H\\ --nocolor\\ --nogroup"
	"	break
	"endif
	"unlet tmp
endfor

"set autowrite                  " Automatically save before commands like :next and :make
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,.exe
"set autochdir                  " move to the directory of the edited file
set sessionoptions-=options    " do not store global and local values in a session
set sessionoptions-=folds      " do not store folds
set switchbuf=usetab           " This option controls the behavior when switching between buffers.
set printoptions=paper:a4,syntax:n " controls the default paper size and the printing of syntax highlighting (:n -> none)

" enable persistent undo and save all undo files in ~/.vimundo
if has('persistent_undo')
	exec 'set undodir='.fnameescape(g:vimdir.g:sep.'tmp'.g:sep.'undo')
	set undofile
	if ! isdirectory(&undodir)
		call mkdir(&undodir, 'p')
	endif
endif

" Visual Settings:
" ----------------

set noerrorbells         " disable error bells
set novisualbell         " disable beep
set wildmode=list:longest,full   " Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
set wildignore=*.o,*.obj,*.pyc,*.swc,*.DS_STORE,*.bkp
set wildmenu             " When 'wildmenu' is on, command-line completion operates in an enhanced mode.
set wildcharm=<C-Z>      " Shortcut to open the wildmenu when you are in the command mode - it's similar to <C-D>
set showmode             " If in Insert, Replace or Visual mode put a message on the last line.
set guifont=Ubuntu\ Mono\ 10 " guifont + fontsize
set guicursor=a:blinkon0 " cursor-blinking off!!
set ruler                " show the cursor position all the time
set nowrap               " kein Zeilenumbruch
set foldmethod=indent    " Standardfaltungsmethode
set foldlevel=99         " default fold level
"set foldminlines=0       " number of lines above which a fold can be displayed
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
set ttyfast              " assume a fast tty connection
set display=lastline,uhex " display last line even if it doesn't fit on the line; display non-printables as hex
set showtabline=2        " always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode

" draw the status line
function! StatusLine()
	let winwidth = winwidth(0)
	let current_file = expand('%:t')
	let current_bufnr = bufnr('%')
	let res = current_bufnr.':'
	if current_file == ""
		let current_file = '[No Name]'
	endif
	let res .= current_file
	if &readonly
		let res .= ' [RO]'
	endif
	if ! &modifiable
		if ! &readonly
			let res .= ' '
		endif
		let res .= '[-]'
	elseif &modified
		if ! &readonly
			let res .= ' '
		endif
		let res .= '[+]'
	endif

	let alternate_buffer = ""
	let alternate_bufnr = bufnr('#')
	let alternate_file = expand('#:t')
	if alternate_bufnr != -1 && alternate_bufnr != current_bufnr
		if alternate_file == ""
			let alternate_buffer .= '[No Name]'
		else
			let alternate_buffer .= ' #'.alternate_bufnr.':'.alternate_file
		endif
	endif

	let warnings = ''
	if &bomb
		let warnings .= ' BOM(B)'
	endif
	if &paste
		let warnings .= ' PASTE'
	endif
	if ! &eol
		let warnings .= ' NOEOL'
	endif

	let misc = ''
	if exists('*TagInStatusLine')
		let misc .= ' '.TagInStatusLine()
	endif

	if (len(res) + len(alternate_buffer) + 20) < winwidth
		let res .= alternate_buffer
	endif
	if (len(res) + len(warnings) + 20) < winwidth
		let res .= warnings
	endif
	if (len(res) + len(misc) + 20) < winwidth
		let res .= misc
	endif
	return res
endfunction

function! StatusLineFileInformation()
	" FIXME This function is a workaround for a problem in the statusline
	" setting.
	" When changing %{StatusLine()} to %!StatusLine() function calls like
	" bufnr('%') evaluation is changed. The function calls just return
	" information about the current buffer which makes this makearound
	" unavoidable.
	let l = StatusLine()
	let winwidth = winwidth(0)
	let res = ''
	if len(l) + 30 < winwidth
		let res .= '['.&fileformat.':'.&fileencoding.':'.&filetype.']'
	else
		let res .= '['.&filetype.']'
	endif
	return res
endfunction

set statusline=%{StatusLine()}%=%<%{StatusLineFileInformation()}\ %l,%c/%vv\ %P " statusline
set mouse=a              " full mouse support
"set foldcolumn=1         " show folds
"set colorcolumn=72       " color specified column in order to help respecting line widths
set nonumber             " draw linenumbers
set nolist               " list nonprintable characters
set sidescroll=0         " scroll X columns to the side instead of centering the cursor on another screen
set completeopt=menuone  " show the complete menu even if there is just one entry
set listchars=tab:>\ ,trail:-,precedes:<,extends:> " display the following nonprintable characters
if $LANG =~ ".*\.UTF-8$" || $LANG =~ ".*utf8$" || $LANG =~ ".*utf-8$"
	try
		set listchars=tab:»\ ,trail:·,precedes:…,extends:…
		set list
	catch
	endtry
endif
set guioptions=aegitcm   " disabled menu in gui mode
"set guioptions=aegimrLtT
set cpoptions=aABceFsq  " q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
" $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
" v: Backspaced characters remain visible on the screen in Insert mode.

" default color scheme
if has("gui_running")
	let w:solarized_style = 'light'
	set background=light
	colorscheme solarized
else
	colorscheme peaksea
endif

if &t_Co > 2 || has("gui_running")
	syntax on " syntax highlighting
endif


" Text Settings:
" --------------

"set virtualedit=onemore      " allow the cursor to move beyond the last character of a line
set smartindent              " always set smartindenting on - deprecated, cindent is the way to go
"set cindent                  " always use cindent
set autoindent               " always autoindent
set copyindent               " always copy indentation level from previous line
set backspace=2              " Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
set textwidth=0              " Don't wrap lines by default
set shiftwidth=4             " number of spaces to use for each step of indent
set tabstop=4                " number of spaces a tab counts for
set noexpandtab              " insert spaces instead of tab if set
set smarttab                 " insert spaces only at the beginning of the line
set ignorecase               " Do case insensitive matching
set smartcase                " overwrite ignorecase if pattern contains uppercase characters
set formatoptions=lcrqn      " no automatic linebreak
set pastetoggle=<F11>        " put vim in pastemode - usefull for pasting in console-mode
set fileformats=unix,dos,mac " favorite fileformats
set encoding=utf-8           " set default-encoding to utf-8
set iskeyword+=_,-           " these characters also belong to a word
"set matchpairs+=<:>          " angle brackets should also being matched by %
