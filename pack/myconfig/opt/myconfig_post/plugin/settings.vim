" Global Settings:
" ----------------

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modeline
set modelines=5


" Miscellaneous Settings:
" -----------------------

set path=.,,                   " limit path
set swapfile                   " write swap files
set directory=~/.cache/vim/swap//  " place swap files outside the current directory
set nobackup                   " don't write backup copies
set writebackup                " write a backup before writing a file
set gdefault                   " substitute all matches by default
set ignorecase                 " ignore case by default for search patterns
set magic                      " special characters that can be used in search patterns
set hidden                     " allow hidden buffers with modifications
set whichwrap=<,>              " Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
set backspace=indent,eol,start " more powerful backspacing
set viminfo='20,\"50           " read/write a .viminfo file, don't store more than
set grepprg=rg\ --vimgrep      " use ripgrep

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,.exe
set sessionoptions-=options    " do not store global and local values in a session
set sessionoptions-=folds      " do not store folds
set switchbuf=usetab           " This option controls the behavior when switching between buffers.
set printoptions=paper:a4,syntax:n " controls the default paper size and the printing of syntax highlighting (:n -> none)

" enable persistent undo and save all undo files in ~/.cache/vimundo
if has('persistent_undo')
	exec 'set undodir='.fnameescape($HOME.'/.cache/vim/undo//')
	set undofile
	if ! isdirectory(&undodir)
		call mkdir(&undodir, 'p')
	endif
endif

" Visual Settings:
" ----------------

set ttyfast                    " we have a fast terminal connction
set showmode                   " show vim's current mode
set showcmd                    " show vim's current command
set showmatch                  " highlight mathing brackets
set nohlsearch                 " don't highlight search results by default as I'm using them to navigate around
set nowrap                     " don't wrap long lines by default
set mouse=a                    " Enable the use of a mouse
set nocursorline                " Don't show cursorline
set noerrorbells               " disable error bells
set novisualbell               " disable beep
set wildmode=list:longest,full   " Don't start wildmenu immediately but list the alternatives first and then do the completion if the user requests it by pressing wildkey repeatedly
set wildignore-=tmp
set wildignore+=*.DS_STORE,*~,*.o,*.obj,*.pyc,.git,.svn,.hg
set wildcharm=<C-Z>            " Shortcut to open the wildmenu when you are in the command mode - it's similar to <C-D>
set guifont=Hack\ 8            " guifont + fontsize
set guicursor=a:blinkon0       " cursor-blinking off!!
set nofoldenable               " start editing with all folds open
set foldmethod=indent          " Use indent for folding by default
"set foldminlines=0             " number of lines above which a fold can be displayed
set linebreak                  " If on Vim will wrap long lines at a character in 'breakat'
set breakindent                " indent wrapped lines visually
set showtabline=2              " always show tabline, even if there is just one tab, avoid redraw problems when Window is displayed in fullscreen mode
"set foldcolumn=1               " show folds
set colorcolumn=+1             " color specified column in order to help respecting line widths
set number relativenumber      " show linenumbers
set completeopt=menuone,preview  " show the complete menu even if there is just one entry
set splitright                 " put the new window right of the current one
set splitbelow                 " put the new window below the current one
set list                       " list nonprintable characters
if $LANG =~ '.*\.UTF-8$' || $LANG =~ '.*utf8$' || $LANG =~ '.*utf-8$'
	set listchars+=tab:»·,trail:⌴ " list nonprintable characters
	set showbreak=↪\           " identifier put in front of wrapped lines
endif
set fillchars=vert:│,diff:—,fold:—    " get rid of the gab between the vertical bars
set guioptions=aegimtc         " disable scrollbars
set cpoptions=aABceFsqJ        " q: When joining multiple lines leave the cursor at the position where it would be when joining two lines.
                               " $:  When making a change to one line, don't redisplay the line, but put a '$' at the end of the changed text.
                               " v: Backspaced characters remain visible on the screen in Insert mode.
                               " J: a sentence is followed by two spaces
" set synmaxcol=200              " stop syntax highlighting at a certain column to improve speed

" Text Settings:
" --------------

set clipboard-=autoselect    " disable itegration with X11 clipboard
set virtualedit=block        " allow the cursor to move beyond the last character of a line
set copyindent               " always copy indentation level from previous line
set nocindent                " disable cindent - it doesn't go well with formatoptions
set textwidth=80             " default textwidth
set shiftwidth=4             " number of spaces to use for each step of indent
set tabstop=4                " number of spaces a tab counts for
set softtabstop=4            " number of spaces a tab counts for
set expandtab                " insert tabs instead of spaces
set nosmartcase              " smart case search (I don't like it that much since it makes * and # much harder to use)
set formatoptions=crqj        " no automatic linebreak, no whatsoever expansion
set pastetoggle=<F11>        " put vim in pastemode - usefull for pasting in console-mode
" set iskeyword+=_             " these characters also belong to a word
"set matchpairs+=<:>          " angle brackets should also being matched by %
set complete+=i              " scan included files and dictionary (if spell checking is enabled)
