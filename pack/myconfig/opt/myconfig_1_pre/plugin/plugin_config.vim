" Plugin Settings

if (exists("g:loaded_plugin_config") && g:loaded_plugin_config) || &cp
    finish
endif
let g:loaded_plugin_config = 1

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" General vim plugins {{{1
let g:no_mail_maps = 1

" AutoPairs {{{1
let g:AutoPairsMapSpace = 1
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsShortcutFastWrap = '<M-e>'
let g:AutoPairsShortcutToggle = '<M-a>'
let g:AutoPairsShortcutJump = '<M-n>'
let g:AutoPairsMapCh = 0

" blinds {{{1
let g:blinds_guibg = "#cdcdcd"

" Characterize {{{1
nmap ga :<C-u>nunmap ga<Bar>packadd characterize<CR><Plug>(characterize)

" CrefVim {{{1
" don't load cref plugin
let loaded_crefvim = 1

" Current Word {{{1
hi CurrentWordTwins gui=underline cterm=underline
hi link CurrentWord CurrentWordTwins

" Coc {{{1
" see https://github.com/neoclide/coc.nvim
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd! CursorHold * silent call CocActionAsync('highlight')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" imap <silent> <C-x><C-o> \<Plug>(coc-complete-custom)
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> [R <Plug>(coc-references)
nmap <silent> cor <Plug>(coc-rename)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" dirvish {{{1
let g:dirvish_mode = ':sort ,^.*[\/],'

let g:loaded_netrwPlugin = 1 " disable netrw .. but I want to have the gx command!!
nmap gx <Plug>NetrwBrowseX
nno <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
vmap gx <Plug>NetrwBrowseXVis
vno <silent> <Plug>NetrwBrowseXVis :<c-u>call netrw#BrowseXVis()<cr>

command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

augroup my_dirvish_events
    autocmd!
    " Map t to "open in new tab".
    autocmd FileType dirvish
                \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
                \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

    " Enable :Gstatus and friends.
    " autocmd FileType dirvish call fugitive#detect(@%)

    " Map `gh` to hide dot-prefixed files.
    " To "toggle" this, just press `R` to reload.
    autocmd FileType dirvish nnoremap <silent><buffer>
                \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>

    autocmd FileType dirvish nnoremap <buffer>
                \ <space>e :e %/
augroup END

" Diffwindow Management {{{1
nnoremap ]C :<C-u>packadd CountJump<Bar>packadd diffwindow_movement<Bar>call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :<C-u>packadd CountJump<Bar>packadd diffwindow_movement<Bar>call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

" EasyBuffer {{{1
let g:easybuffer_chars = ['a', 's', 'f', 'i', 'w', 'e', 'z', 'c', 'v']

" Easy Align {{{1
xmap g= <Plug>(EasyAlign)
nmap g= <Plug>(EasyAlign)
nmap g/ g=ip*\|

" editorconfig {{{1
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" editqf {{{1
nnoremap <leader>n :<C-u>nunmap <leader>n<Bar>packadd editqf<Bar>QFAddNote<CR>

" floaterm {{{1
let g:floaterm_autoclose = 1
let g:floaterm_shell = 'fish'
nnoremap <silent> <M-y> :FloatermPrev<CR>
tnoremap <silent> <M-y> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <M-;> :FloatermNext<CR>
tnoremap <silent> <M-;> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <M-,> :FloatermToggle<CR>
tnoremap <silent> <M-,> <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> <M-t> :FloatermNew<CR>
tnoremap <silent> <M-t> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <M-e> :FloatermNew nnn<CR>
tnoremap <silent> <M-e> <C-\><C-n>:FloatermNew nnn<CR>

" Fugitive {{{1
autocmd BufReadPost fugitive://* set bufhidden=delete

" FuzzyFinder {{{1
" function! Expand_file_directory()
"        let l:dir = expand('%:p:h')
"        if l:dir == ''
"                let l:dir = getcwd()
"        endif
"        let l:dir .= '/'
"        return fnameescape(l:dir)
" endfunction

" autocmd! FileType fuf
" autocmd  FileType fuf set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" autocmd FileType fuf let b:deoplete_disable_auto_complete = 1

" let g:fuf_keyNextMode = '<C-l>'
" let g:fuf_keyOpenSplit = '<C-s>'
" let g:fuf_keyOpenTabpage =  '<C-t>'
" let g:fuf_keyOpenVsplit =  '<C-v>'
" let g:fuf_keyPrevPattern = '<C-k>'
" let g:fuf_keyNextPattern = '<C-j>'
" let g:fuf_modesDisable     = [ 'tag', 'taggedfile', 'quickfix', 'jumplist', 'changelist', 'line' ]
" let g:fuf_scratch_location = 'botright'
" let g:fuf_maxMenuWidth     = 300
" let g:fuf_file_exclude     = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
" let g:fuf_previewHeight    = 0

" ftplugin: svelte {{{1

function! OnChangeSvelteSubtype(subtype)
  echo 'Subtype is '.a:subtype
  if empty(a:subtype) || a:subtype == 'html'
    setlocal commentstring=<!--%s-->
    setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
  elseif a:subtype =~ 'css'
    setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
  else
    setlocal commentstring=//%s
    setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
  endif
endfunction

" fzf.vim {{{1
" More options: https://github.com/junegunn/fzf/blob/master/README-VIM.md
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6 } }

" GhostText {{{1
if exists(':GhostStart') != 2
    command! -nargs=0 GhostStart :delc GhostStart|packadd ghosttext|GhostStart
endif

" Go {{{1
" let g:go_metalinter_enabled = 0 " disable linter because ale is taking care of that
" let g:go_gopls_enabled = 0 " disable lsp since I'm using CoC

" Goyo {{{1
function! TmuxMaximize()
  " tmux
  if exists('$TMUX')
      silent! !tmux set-option status off
      silent! !tmux resize-pane -Z
  endif
endfun
function! TmuxRestore()
  " tmux
  if exists('$TMUX')
      silent! !tmux set-option status on
      silent! !tmux resize-pane -Z
  endif
endfun
let g:goyo_callbacks = [ function("TmuxMaximize"), function("TmuxRestore") ]

" Gundo {{{1
if exists(':GundoToggle') != 2
	command! -nargs=0 GundoToggle :delc GundoToggle|packadd gundo|GundoToggle
endif

" Hier {{{1
" disable highlighting for location list entries
let g:hier_highlight_group_loc  = ''
let g:hier_highlight_group_locw = ''
let g:hier_highlight_group_loci = ''

if exists(':HierUpdate') != 2
	command! -nargs=0 HierStart :delc HierUpdate|delc HierStart|packadd hier|HierStart
	command! -nargs=0 HierUpdate :delc HierUpdate|delc HierStart|packadd hier|HierUpdate
endif

" Interesting words {{{1
nmap <C-k> <cmd>call InterestingWords('n')<CR>
vmap <C-k> <cmd>call InterestingWords('n')<CR>
command! InterestingWordsClear :call UncolorAllWords()

" LanguageTool {{{1
let g:languagetool_jar=$HOME . '/.config/nvim/pack/vimscripts/opt/LanguageTool/LanguageTool/languagetool-commandline.jar'
if exists(':LanguageToolCheck') != 2
    command! -nargs=0 LanguageToolCheck :delc LanguageToolCheck|packadd LanguageTool|LanguageToolCheck
endif

" lightline {{{1
let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ 'component': {
            \   'bomb': '%{&bomb?"💣":""}',
            \   'diff': '%{&diff?"◑":""}',
            \   'lineinfo': ' %3l:%-2v',
            \   'modified': '%{&modified?"±":""}',
            \   'noeol': '%{&endofline?"":"!↵"}',
            \   'readonly': '%{&readonly?"":""}',
            \   'scrollbind': '%{&scrollbind?"∞":""}',
            \ },
            \ 'component_visible_condition': {
            \   'bomb': '&bomb==1',
            \   'diff': '&diff==1',
            \   'modified': '&modified==1',
            \   'noeol': '&endofline==0',
            \   'scrollbind': '&scrollbind==1',
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightLineFugitive',
            \   'neomake': 'LightLineNeomake'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ 'active' : {
            \ 'left': [ [ 'winnr', 'neomake', 'mode', 'paste' ],
            \           [ 'bomb', 'diff', 'scrollbind', 'noeol', 'readonly', 'fugitive', 'filename', 'modified' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ],
            \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'inactive' : {
            \ 'left': [ [ 'winnr', 'diff', 'scrollbind', 'filename', 'modified' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ] ]
            \ },
            \ }

function! LightLineFugitive()
    if exists('*fugitive#head')
        let _ = fugitive#head()
        return strlen(_) ? _ . ' ' : ''
    endif
    return ''
endfunction

function! LightLineNeomake()
    let l:jobs = neomake#GetJobs()
    if len(l:jobs) > 0
        return len(l:jobs).'⚒'
    endif
    return ''
endfun

" Markdown Preview {{{1
if exists('g:mkdp_auto_start') == 0
    command! -nargs=0 MarkdownPreview :delc MarkdownPreview|packadd markdown-preview|doautocmd BufEnter|MarkdownPreview
endif

" Maximizer {{{1
let g:maximizer_restore_on_winleave = 1

" Neoformat {{{1
if exists(':Neoformat') != 2
    command! -nargs=* -bang Neoformat :delc Neoformat|packadd neoformat|Neoformat<bang> <args>
endif

let g:neoformat_yaml_yq = {
            \ 'exe': 'yq',
            \ 'args': ['-P', 'eval', '.', '-'],
            \ 'stdin': 1,
            \ 'no_append': 1,
            \ }

let g:neoformat_enabled_yaml = ['yq']

" NeoMake {{{1
let g:neomake_plantuml_default_maker = {
            \ 'exe': 'plantuml',
            \ 'args': [],
            \ 'errorformat': '%EError\ line\ %l\ in\ file:\ %f,%Z%m',
            \ }
let g:neomake_plantuml_svg_maker = {
            \ 'exe': 'plantumlsvg',
            \ 'args': [],
            \ 'errorformat': '%EError\ line\ %l\ in\ file:\ %f,%Z%m',
            \ }
let g:neomake_plantuml_pdf_maker = {
            \ 'exe': 'plantumlpdf',
            \ 'args': [],
            \ 'errorformat': '%EError\ line\ %l\ in\ file:\ %f,%Z%m',
            \ }
let g:neomake_plantuml_enabled_makers = ['default']

" neoterm {{{1
let g:neoterm_direct_open_repl=0
let g:neoterm_open_in_all_tabs=1
let g:neoterm_autoscroll=1
let g:neoterm_term_per_tab=1
let g:neoterm_shell="fish"
let g:neoterm_autoinsert=1
let g:neoterm_automap_keys='<F23>'

" Netrw {{{1
let g:netrw_browsex_viewer= "xdg-open-background"

" NvimTree {{{1
" if exists(':CHADopen') != 2
"     command! -nargs=0 NvimTreeToggle :delc NvimTreeToggle|packadd nvimtree|NvimTreeToggle
" endif

let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_gitignore = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_follow = 1
let g:nvim_tree_indent_markers = 1

lua <<EOF
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
    { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
    { key = {"<2-RightMouse>", "<C-]>"},    cb = tree_cb("cd") },
    { key = "<C-v>",                        cb = tree_cb("vsplit") },
    { key = "<C-x>",                        cb = tree_cb("split") },
    { key = "<C-t>",                        cb = tree_cb("tabnew") },
    { key = "<",                            cb = tree_cb("prev_sibling") },
    { key = ">",                            cb = tree_cb("next_sibling") },
    { key = "P",                            cb = tree_cb("parent_node") },
    { key = "<BS>",                         cb = tree_cb("close_node") },
    { key = "<S-CR>",                       cb = tree_cb("close_node") },
    { key = "<Tab>",                        cb = tree_cb("preview") },
    { key = "K",                            cb = tree_cb("first_sibling") },
    { key = "J",                            cb = tree_cb("last_sibling") },
    { key = "I",                            cb = tree_cb("toggle_ignored") },
    { key = "H",                            cb = tree_cb("toggle_dotfiles") },
    { key = "R",                            cb = tree_cb("refresh") },
    { key = "a",                            cb = tree_cb("create") },
    { key = "d",                            cb = tree_cb("remove") },
    { key = "r",                            cb = tree_cb("rename") },
    { key = "<C-r>",                        cb = tree_cb("full_rename") },
    { key = "x",                            cb = tree_cb("cut") },
    { key = "c",                            cb = tree_cb("copy") },
    { key = "p",                            cb = tree_cb("paste") },
    { key = "y",                            cb = tree_cb("copy_name") },
    { key = "Y",                            cb = tree_cb("copy_path") },
    { key = "gy",                           cb = tree_cb("copy_absolute_path") },
    { key = "[c",                           cb = tree_cb("prev_git_item") },
    { key = "]c",                           cb = tree_cb("next_git_item") },
    { key = "-",                            cb = tree_cb("dir_up") },
    { key = "q",                            cb = tree_cb("close") },
    { key = "g?",                           cb = tree_cb("toggle_help") },
    }
EOF

" Man {{{1
" load manpage-plugin
"runtime! ftplugin/man.vim
" cut startup time dramatically by loading the man plugin on demand
if exists(':Man') != 2
	command! -nargs=+ Man :delc Man|runtime! ftplugin/man.vim|Man <args>
endif

" PaperColor {{{1
            " \     'transparent_background': 1,
let g:PaperColor_Theme_Options = {
            \ 'theme': {
            \   'default.light': {
            \     'transparent_background': 1,
            \     'override': {
            \       'color04' : ['#87afd7', '110'],
            \       'color16' : ['#87afd7', '110'],
            \       'statusline_active_fg' : ['#444444', '238'],
            \       'statusline_active_bg' : ['#eeeeee', '255'],
            \       'visual_bg' : ['#005f87', '110'],
            \       'folded_fg' : ['#005f87', '31'],
            \       'difftext_fg':   ['#87afd7', '110'],
            \       'tabline_inactive_bg': ['#87afd7', '110'],
            \       'buftabline_inactive_bg': ['#87afd7', '110']
            \     }
            \   }
            \ }
            \ }

" Python Highlighting {{{1
let python_highlight_all = 1

" python-mode {{{1
let g:pymode_python = 'python3'
let g:pymode_lint = 0 " disable linter because ale takes care of that
let g:pymode_rope = 0
let g:pymode_lint_ignore = "E501,W191"
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']

" Repmo {{{1

" map a motion and its reverse motion:
noremap <expr> h repmo#SelfKey('h', 'l') | sunmap h
noremap <expr> l repmo#SelfKey('l', 'h') | sunmap l
noremap <expr> <C-E> repmo#SelfKey('<C-E>', '<C-Y>') | sunmap <C-E>
noremap <expr> <C-Y> repmo#SelfKey('<C-Y>', '<C-E>') | sunmap <C-Y>
noremap <expr> <C-D> repmo#SelfKey('<C-D>', '<C-U>') | sunmap <C-D>
noremap <expr> <C-U> repmo#SelfKey('<C-U>', '<C-D>') | sunmap <C-U>
noremap <expr> <C-F> repmo#SelfKey('<C-F>', '<C-B>') | sunmap <C-F>
noremap <expr> <C-B> repmo#SelfKey('<C-B>', '<C-F>') | sunmap <C-B>
noremap <expr> e repmo#SelfKey('e', 'ge') | sunmap e
noremap <expr> ge repmo#SelfKey('ge', 'e') | sunmap ge
noremap <expr> b repmo#SelfKey('b', 'w') | sunmap b
noremap <expr> w repmo#SelfKey('w', 'b') | sunmap w
noremap <expr> B repmo#SelfKey('B', 'W') | sunmap B
noremap <expr> W repmo#SelfKey('W', 'B') | sunmap W

" repeat the last [count]motion or the last zap-key:
map <expr> ; repmo#LastKey(';')|sunmap ;
map <expr> , repmo#LastRevKey(',')|sunmap ,

" add these mappings when repeating with `;' or `,':
noremap <expr> f repmo#ZapKey('f', 1) | sunmap f
noremap <expr> F repmo#ZapKey('F', 1) | sunmap F
noremap <expr> t repmo#ZapKey('t', 1) | sunmap t
noremap <expr> T repmo#ZapKey('T', 1) | sunmap T

" Restconsole {{{1
augroup ft_rest
  au!
  au BufReadPost,BufNewFile *.rest		packadd rest-console|setf rest
augroup END
command! -nargs=0 Restconsole :packadd rest-console|if &ft != "rest"|new|set ft=rest|endif
" let g:vrc_show_command = 1
let g:vrc_show_command = 0
let g:vrc_curl_opts = {
            \ '--connect-timeout' : 10,
            \ '-L': '',
            \ '-i': '',
            \ '--max-time': 60,
            \ '-k': '',
            \ '-sS': '',
            \}
            " \ '-v': '',
            " \ '-H': 'accept: application/json',
let g:vrc_auto_format_response_patterns = {
  \ 'json': 'jq .',
  \ 'xml': 'xmllint --format -',
\}

" rsi {{{1
let g:rsi_no_meta = 1

" Speeddating {{{1
let g:speeddating_no_mappings = 1
nnoremap <Plug>SpeedDatingFallbackUp <C-a>
nnoremap <Plug>SpeedDatingFallbackDown <C-x>

" Subversive {{{1
nmap gR <plug>(SubversiveSubstituteToEndOfLine)
nmap gr <plug>(SubversiveSubstitute)
nmap grr <plug>(SubversiveSubstituteLine)

nmap grs <plug>(SubversiveSubstituteRange)
xmap grs <plug>(SubversiveSubstituteRange)
nmap grss <plug>(SubversiveSubstituteWordRange)

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<cr>

" iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>

" Surround {{{1
let g:surround_no_insert_mappings = 1

" Swapit {{{1
nmap <silent> <Plug>SwapItFallbackIncrement :<C-u>let sc=v:count1<Bar>packadd speeddating<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>
nmap <silent> <Plug>SwapItFallbackDecrement :<C-u>let sc=v:count1<Bar>packadd speeddating<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>
nmap <silent> <C-a> :<C-u>let swap_count = v:count<Bar>packadd swapit<Bar>call SwapWord(expand("<cword>"), swap_count, 'forward', 'no')<Bar>silent! call repeat#set("\<Plug>SwapIncrement", swap_count)<Bar>unlet swap_count<CR>
nmap <silent> <C-x> :<C-u>let swap_count = v:count<Bar>packadd swapit<Bar>call SwapWord(expand("<cword>"), swap_count, 'backward','no')<Bar>silent! call repeat#set("\<Plug>SwapDecrement", swap_count)<Bar>unlet swap_count<CR>

" TComment {{{1
let g:tcomment_mapleader1 = ''
let g:tcomment_mapleader2 = ''

function! InsertCommentstring()
	let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
	let col = col('.')
	let line = line('.')
	let g:ics_pos = [line, col + strlen(l)]
	return l.r
endfunction
function! ICSPositionCursor()
	call cursor(g:ics_pos[0], g:ics_pos[1])
	unlet g:ics_pos
endfunction
inoremap <C-c> <C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>

" terraform {{{1
let g:terraform_fmt_on_save = 1

" Telescope {{{1
highlight link TelescopeMatching IncSearch
lua << EOF
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
-- Global remapping
------------------------------
require('telescope').load_extension('fzy_native')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<c-x>"] = false,
        ["<C-s>"] = actions.file_split,
        -- ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  }
}
EOF

" thesaurus_query {{{1
let g:tq_map_keys = 1
let g:tq_use_vim_autocomplete = 0
let g:tq_language = ['en', 'de']

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" treesitter {{{1
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false
  }
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" unimpaired {{{1

" disable legacy mappings
nmap co <Nop>
nmap =o <Nop>

" UltiSnips {{{1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsExpandTrigger = '<c-h>'

" Vista {{{1
if exists(':Vista') != 2
    command! -bang -nargs=* Vista :delc Vista|packadd vista|Vista<bang> <args>
endif
let g:vista_sidebar_width = 50

" VisIncr {{{1
if exists(':I') != 2
    command! -range -nargs=* I :delc I|delc II|packadd VisIncr|I <args>
    command! -range -nargs=* II :delc I|delc II|packadd VisIncr|II <args>
endif

" Visual Mode {{{1

let g:VM_maps = {}
" let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}

" XML Ftplugin {{{1
let xml_use_xhtml = 1

" Yoink {{{1
let g:yoinkAutoFormatPaste = 0 " this doesn't work properly, so fix it to <F11> manualy
let g:yoinkMaxItems = 20

nmap <M-n> <plug>(YoinkPostPasteSwapBack)
nmap <M-p> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" vi {{{1
" vi: ft=vim:tw=80:sw=4:ts=4:sts=4:et:fdm=marker
