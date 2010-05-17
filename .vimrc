" Author: Jan Christoph Ebersbach jceb AT e-jc DOT de

" ToC - use UTL to jump to the entries
" <url:#r=Settings>
" <url:#r=Special Configuration>
" <url:#r=Autocommands>
" <url:#r=Highlighting and Colors>
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
for i in ['ack-grep', 'ack']
	let tmp = ""
	try
		let tmp = substitute (system ('which '.i), '\n.*', '', '')
	catch
	endtry
	if v:shell_error == 0
		exec "set grepprg=".tmp."\\ -a\\ -H\\ --nocolor\\ --nogroup"
		break
	endif
	unlet tmp
endfor
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
set listchars=tab:>-,trail:-,precedes:<,extends:> " display the following nonprintable characters
if $LANG =~ ".*\.UTF-8$" || $LANG =~ ".*utf8$" || $LANG =~ ".*utf-8$"
	try
		set listchars=tab:»·,trail:·,precedes:…,extends:…
		set list
	catch
	endtry
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
elseif $TERM == "linux"
	set background=dark " use colors that fit to a dark background
else
	set background=light " use colors that fit to a light background
	"set background=dark " use colors that fit to a dark background
endif

if &t_Co > 2 || has("gui_running")
	syntax on " syntax highlighting
endif

" ########## text options ##########
"set virtualedit=onemore      " allow the cursor to move beyond the last character of a line
set smartindent              " always set smartindenting on
set autoindent               " always set autoindenting on
set copyindent               " always set copyindenting on
set backspace=2              " Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
set textwidth=0              " Don't wrap words by default
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

if has("autocmd")
	filetype plugin on " automatically load filetypeplugins
	filetype indent on " indent according to the filetype

	augroup filetypesettings
		autocmd!
		" Do word completion automatically
		au FileType debchangelog	setlocal expandtab
		au FileType tex,plaintex	setlocal makeprg=pdflatex\ \"%:p\"
		au FileType java,c,cpp		setlocal noexpandtab nosmarttab
		au FileType mail			setlocal textwidth=72 formatoptions=ltcrqna comments+=b:--
		au FileType mail			call FormatMail()
		au FileType txt				setlocal formatoptions=ltcrqn textwidth=72
		au FileType asciidoc,mkd,tex	setlocal formatoptions=ltcrqn textwidth=72
		au FileType xml,docbk,xhtml,jsp	setlocal formatoptions=lcrq
		au FileType ruby			setlocal shiftwidth=2
		au FileType help			setlocal nolist textwidth=0

		au BufReadPost,BufNewFile *		setlocal formatoptions-=o " o is really annoying

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
		au BufReadPost *	if expand('%') !~ '^\[Lusty' && &buftype == '' && &modifiable == 1 && &buflisted == 1 && line("'\"") > 1 && line("'\"") <= line("$") && &filetype != "mail" | exe "normal g`\"" | endif

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

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Highlighting and Colors ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" un/highlight current line
nnoremap <silent> <Leader>H :match<CR>
nnoremap <silent> <Leader>h mk:exe 'match Search /<Bslash>%'.line(".").'l/'<CR>

" clear search register, useful if you want to get rid of too much highlighting
nnoremap <silent> <leader>/ :let @/ = ""<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Plugin Settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" load manpage-plugin
runtime! ftplugin/man.vim

" load matchit-plugin
runtime! macros/matchit.vim

" neocomplcache
" -------------
" Use neocomplcache.
""let g:NeoComplCache_EnableAtStartup = 1
""" Use smartcase.
""let g:NeoComplCache_SmartCase = 1
""" Use camel case completion.
""let g:NeoComplCache_EnableCamelCaseCompletion = 1
""" Use underbar completion.
""let g:NeoComplCache_EnableUnderbarCompletion = 1
""" Set minimum syntax keyword length.
""let g:NeoComplCache_MinSyntaxLength = 3
""
""" Define dictionary.
""let g:NeoComplCache_DictionaryFileTypeLists = {
""	\ 'default' : '',
""	\ 'vimshell' : $HOME.'/.vimshell_hist',
""	\ 'scheme' : $HOME.'/.gosh_completions'
""		\ }
""
""" Define keyword.
""if !exists('g:NeoComplCache_KeywordPatterns')
""	let g:NeoComplCache_KeywordPatterns = {}
""endif
""let g:NeoComplCache_KeywordPatterns['default'] = '\h\w*'
""
""" Plugin key-mappings.
""imap <C-j>     <Plug>(neocomplcache_snippets_expand)
""smap <C-j>     <Plug>(neocomplcache_snippets_expand)
"""inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
"""inoremap <expr><C-g>     neocomplcache#undo_completion()
"""inoremap <expr><C-l>     neocomplcache#complete_common_string()

" txtbrowser
" ----------
" don't load the plugin cause it's not helpful for my workflow
" id=txtbrowser_disabled
let g:txtbrowser_version = "don't load!"

" fastwordcompleter
" -----------------
"let g:loaded_fastwordcompletion = 1 " obsoleted by neocomplcache
let g:fastwordcompleter_filetypes = '*'
"let g:fastwordcompleter_filetypes = 'asciidoc,mkd,txt,mail,help'

" netrw
" -----
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" GetLatestVimScripts
" -------------------
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

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
let g:yankring_ignore_operator = 'g~ gu gU ! = gq g? > < zf g@'
let g:yankring_history_file = '.yankring_history_file'
let g:yankring_map_dot = 0

" Supertab
" --------
let g:SuperTabDefaultCompletionType = "<c-n>"

" TagList
" -------
let Tlist_Sort_Type = "order"
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

" NERD Tree explorer
" ------------------
nmap <leader>e :NERDTreeToggle<CR>

" TaskList settings
" -----------------
let g:tlWindowPosition = 1
nnoremap <F12> <Plug>TaskList

" delimitMate
" -----------
"let g:delimitMate_matchpairs = "[:],(:),{:},<:>" " braces that shall be closed autoamtically
"let g:delimitMate_quotes = ""
"let g:delimitMate_apostrophes = ""
let g:delimitMate_tab2exit = 0

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
" copy link
nnoremap gcc :Utl cl<CR>
vnoremap gcc :Utl cl v<CR>

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

" txtfmt
" ------
" disable map warnings and overwrite any conflicts
let g:txtfmtMapwarn = "cC"

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Keymappings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Jump behind the next closing brace and start editing
inoremap <C-j> <Esc>l%%a
nnoremap <C-j> %%l

" kill/delete trailing spaces and tabs
nnoremap <Leader>kt msHmt:silent! g!/^-- $/s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing spaces"<CR>'tzt`s
vnoremap <Leader>kt :s/[\t \x0d]\+$//g<CR>:let @/ = ""<CR>:echo "Deleted trailing, spaces"<CR>

" kill/reduce inner spaces and tabs to a single space/tab
nnoremap <Leader>ki msHmt:silent! %s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>'tzt`s
vnoremap <Leader>ki :s/\([^\xa0\x0d\t ]\)[\xa0\x0d\t ]\+\([^\xa0\x0d\t ]\)/\1 \2/g<CR>:let @/ = ""<CR>:echo "Deleted inner spaces"<CR>

" remove word delimiter from search term
function! Remove_word_delimiter_from_search()
	let tmp = substitute(substitute(@/, '^\\<', '', ''), '\\>$', '', '')
	execute "normal! /" . tmp
	let @/ = tmp
	unlet tmp
endfunction
nnoremap <silent> <leader>> :call Remove_word_delimiter_from_search()<CR>
nmap <silent> <leader>< <leader>>

" browse current buffer/selection in www-browser
"nnoremap <Leader>b :!x-www-browser %:p<CR>:echo "WWW-Browser started"<CR>
"vnoremap <Leader>b y:!x-www-browser <C-R>"<CR>:echo "WWW-Browser started"<CR>

" lookup/translate inner/selected word in dictionary
" recode is only needed for non-utf-8-text
" nnoremap <Leader>T mayiw`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
nnoremap <Leader>t mayiw`a:exe "!dict -P - -- " . @"<CR>
" vnoremap <Leader>T may`a:exe "!dict -P - -- $(echo " . @" . "\| recode latin1..utf-8)"<CR>
vnoremap <Leader>t may`a:exe "!dict -P - -- " . @"<CR>

" copy/paste to/from clipboard
nnoremap gp "+p
vnoremap gy "+y
" actually gY is not that useful because the visual mode will do the same
"vnoremap gY "*y
"nnoremap gP "*p

" replace within the visual selection
vnoremap gvs :<BS><BS><BS><BS><BS>%s/\%V

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

" fast quit with save
nnoremap <silent> ZZ :wa<CR>:qa<CR>

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

" edit/reload .vimrc-Configuration
command! ConfigEdit :e $HOME/.vimrc
command! ConfigVertical :vs $HOME/.vimrc
command! ConfigSplit :sp $HOME/.vimrc
command! ConfigReload :source $HOME/.vimrc|echo "Configuration reloaded"

" spellcheck off, german, englisch
command! -nargs=1 Spell :setlocal spell spelllang=<args>
command! -nargs=0 Nospell :setlocal nospell

" delete buffer while keeping the window structure
command! Bk :enew<CR>bw #<CR>bn<CR>bw #

" create tags file in current working directory
command! MakeTags :silent !ctags -R *

" 'Tw' set the textwidth and update the printmarign highlighting in one step
command! -nargs=1 Tw set tw=<args> | call HighlightPrintmargin()

" Shortcut to reload UltiSnips Manager
"command! ResetUltiSnips :py UltiSnips_Manager.reset()

" Make current file executeable
command! -nargs=0 Chmodx :!chmod +x %

""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- id=Personal settings ----------
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" source other personal settings
runtime! personal.vim
