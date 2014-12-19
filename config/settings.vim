" Global Settings:
" ----------------

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modeline
set modelines=5


" Miscellaneous Settings:
" -----------------------

set whichwrap=<,>              " Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
set backspace=indent,eol,start " more powerful backspacing
set viminfo='20,\"50           " read/write a .viminfo file, don't store more than
set magic                      " special characters that can be used in search patterns
set grepprg=grep\ --exclude='*.svn-base'\ -n\ $*\ /dev/null " don't grep through svn-base files
" Try do use the ack program when available
for i in ['ag', 'ack-grep', 'ack']
	let tmp = '/usr/bin/'.i
	if filereadable(tmp)
		exec 'set grepprg='.tmp.'\ --nocolor\ --nogroup\ --column'
		set grepformat=%f:%l:%c:%m
		break
	endif
	"let tmp = ''
	"try
	"	let tmp = substitute(system('which '.i), '\n.*', '', '')
	"catch
	"endtry
	"if v:shell_error == 0
	"	exec 'set grepprg='.tmp.'\\ -a\\ -H\\ --nocolor\\ --nogroup'
	"	break
	"endif
	"unlet tmp
endfor

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,.exe
set sessionoptions-=options    " do not store global and local values in a session
set sessionoptions-=folds      " do not store folds
set switchbuf=usetab           " This option controls the behavior when switching between buffers.
set printoptions=paper:a4,syntax:n " controls the default paper size and the printing of syntax highlighting (:n -> none)

" enable persistent undo and save all undo files in ~/.cache/vimundo
if has('persistent_undo')
	exec 'set undodir='.fnameescape($HOME.g:sep.'.cache'.g:sep.'vim'.g:sep.'undo')
	set undofile
	if ! isdirectory(&undodir)
		call mkdir(&undodir, 'p')
	endif
endif

" Visual Settings:
" ----------------

set cursorline           " Show cursorline
set noerrorbells         " disable error bells
set novisualbell         " disable beep
set wildmode=list:longest,full   " Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
set wildignore+=*.swc,*.DS_STORE,*.bkp,*~
set wildignore-=tmp
set wildcharm=<C-Z>      " Shortcut to open the wildmenu when you are in the command mode - it's similar to <C-D>
set guifont=Source\ Code\ Pro\ for\ Powerline\ Regular\ 9 " guifont + fontsize
set guicursor=a:blinkon0 " cursor-blinking off!!
set foldmethod=indent    " Use indent for folding by default
"set foldminlines=0       " number of lines above which a fold can be displayed
set linebreak            " If on Vim will wrap long lines at a character in 'breakat'
set breakindent          " indent wrapped lines visually
set showtabline=2        " always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
"set foldcolumn=1         " show folds
"set colorcolumn=72       " color specified column in order to help respecting line widths
set nonumber             " draw linenumbers
set completeopt=menuone,preview  " show the complete menu even if there is just one entry
set splitright           " put the new window right of the current one
set splitbelow           " put the new window below the current one
set list             " list nonprintable characters
if $LANG =~ '.*\.UTF-8$' || $LANG =~ '.*utf8$' || $LANG =~ '.*utf-8$'
	set listchars+=tab:»·,trail:⌴ " list nonprintable characters
	set showbreak=↪          " identifier put in front of wrapped lines
endif
set guioptions=aegimtc   " disable scrollbars
set cpoptions=aABceFsqJ  " q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
                         " $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
                         " v: Backspaced characters remain visible on the screen in Insert mode.
                         " J: a sentence is followed by two spaces
set synmaxcol=200        " stop syntax highlighting at a certain column to improve speed

" default color scheme
if has('gui_running')
	set background=light
	colorscheme lucius
else
	set background=light
	colorscheme lucius
endif

" override sensible defaults
let &fillchars = 'vert:|,fold:-'
set sidescroll=0         " scroll X columns to the side instead of centering the cursor on another screen


" Text Settings:
" --------------

set clipboard-=autoselect    " disable itegration with X11 clipboard
set virtualedit=block        " allow the cursor to move beyond the last character of a line
set copyindent               " always copy indentation level from previous line
set textwidth=80             " default textwidth
set shiftwidth=4             " number of spaces to use for each step of indent
set tabstop=4                " number of spaces a tab counts for
set softtabstop=4            " number of spaces a tab counts for
set noexpandtab              " insert spaces instead of tab if set
set nosmartcase                " smart case search (I don't like it that much since it makes * and # much harder to use)
set formatoptions=lrq        " no automatic linebreak, no whatsoever expansion
set pastetoggle=<F11>        " put vim in pastemode - usefull for pasting in console-mode
set encoding=utf-8           " set default-encoding to utf-8
set iskeyword+=_             " these characters also belong to a word
"set matchpairs+=<:>          " angle brackets should also being matched by %
