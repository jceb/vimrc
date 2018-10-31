" Plugin Settings

if (exists("g:loaded_plugin_config_pre") && g:loaded_plugin_config_pre) || &cp
    finish
endif
let g:loaded_plugin_config_pre = 1

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" General vim plugins {{{1
let g:no_mail_maps = 1

" AutoPairs {{{1
let g:AutoPairsMapSpace = 0
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = '<C-j>'

" blinds {{{1
let g:blinds_guibg = "#cdcdcd"

" Characterize {{{1
nmap ga :<C-u>nunmap ga<Bar>packadd characterize<CR><Plug>(characterize)

" Colorizer {{{1
let g:colorizer_startup = 0
let g:colorizer_nomap = 1

command! -bang -nargs=0 ColorHighlight :delc ColorHighlight<Bar>packadd colorizer<Bar>ColorHighlight<Bang>

" Commentary {{{1
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
let g:commentary_map_backslash = 0

" CrefVim {{{1
" don't load cref plugin
let loaded_crefvim = 1

" Current Word {{{1
hi CurrentWordTwins gui=underline cterm=underline
hi link CurrentWord CurrentWordTwins

" Coc {{{1
" see https://github.com/neoclide/coc.nvim
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Deoplete {{{1
let g:deoplete#enable_at_startup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"

" dirvish {{{1
let g:dirvish_mode = ':sort ,^.*[\/],'

augroup my_dirvish_events
    autocmd!
    " Map t to "open in new tab".
    autocmd FileType dirvish
                \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
                \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

    " Enable :Gstatus and friends.
    " autocmd FileType dirvish call fugitive#detect(@%)

    " Map `gr` to reload the Dirvish buffer.
    autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

    " Map `gh` to hide dot-prefixed files.
    " To "toggle" this, just press `R` to reload.
    autocmd FileType dirvish nnoremap <silent><buffer>
                \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END

" Diffwindow Management {{{1
nnoremap ]C :<C-u>packadd CountJump<Bar>packadd diffwindow_movement<Bar>call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :<C-u>packadd CountJump<Bar>packadd diffwindow_movement<Bar>call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

" Easy Align {{{1
xmap g= <Plug>(EasyAlign)
nmap g= <Plug>(EasyAlign)

" Easyclip {{{1
let g:EasyClipEnableBlackHoleRedirect = 0
let g:EasyClipUseCutDefaults = 0
let g:EasyClipUsePasteToggleDefaults = 0 " this doesn't work properly, so fix it to <F11> manually
noremap <silent> <F11> :set invpaste<CR>
inoremap <silent> <F11> <C-o>:set invpaste<CR>
let g:EasyClipUseSubstituteDefaults = 0
let g:EasyClipYankHistorySize = 20
nmap grr <Plug>SubstituteLine
nmap gR <Plug>SubstituteToEndOfLine
nmap gr <Plug>SubstituteOverMotionMap

" editorconfig {{{1
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" editqf {{{1
nnoremap <leader>n :<C-u>nunmap <leader>n<Bar>packadd editqf<Bar>QFAddNote<CR>

" Fugitive {{{1
autocmd BufReadPost fugitive://* set bufhidden=delete

" FuzzyFinder {{{1
function! Expand_file_directory()
       let l:dir = expand('%:p:h')
       if l:dir == ''
               let l:dir = getcwd()
       endif
       let l:dir .= '/'
       return fnameescape(l:dir)
endfunction

autocmd! FileType fuf
autocmd  FileType fuf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
autocmd FileType fuf let b:deoplete_disable_auto_complete = 1

let g:fuf_keyNextMode = '<C-l>'
let g:fuf_keyOpenSplit = '<C-s>'
let g:fuf_keyOpenTabpage =  '<C-t>'
let g:fuf_keyOpenVsplit =  '<C-v>'
let g:fuf_keyPrevPattern = '<C-k>'
let g:fuf_keyNextPattern = '<C-j>'
let g:fuf_modesDisable     = [ 'tag', 'taggedfile', 'quickfix', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location = 'botright'
let g:fuf_maxMenuWidth     = 300
let g:fuf_file_exclude     = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight    = 0

" GhostText {{{1
command! -nargs=0 GhostStart :delc GhostStart|packadd ghosttext|GhostStart

" Go {{{1
let g:go_metalinter_enabled = 0 " disable linter because ale is taking care of that

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
nnoremap <Space>u :GundoToggle<CR>

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
nmap <Space>m <Plug>InterestingWords
vmap <Space>m <Plug>InterestingWords
nmap <Space>M <Plug>InterestingWordsClear

" LanguageTool {{{1
let g:languagetool_jar=$HOME . '/.config/nvim/pack/vimscripts/opt/LanguageTool/LanguageTool/languagetool-commandline.jar'
command! -nargs=0 LanguageToolCheck :delc LanguageToolCheck|packadd LanguageTool|LanguageToolCheck

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
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ 'active' : {
            \ 'left': [ [ 'winnr', 'mode', 'paste' ],
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
        return strlen(_) ? '' : ''
    endif
    return ''
endfunction

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
let g:repmo_key    = ';'
let g:repmo_revkey = ','
" don't map hjkl to speed up navigation since I tend forget to use repmo for these movements
" removed n|N - keys generate an error message when nothing is found which is very annoying
let g:repmo_mapmotions = '<C-i>|<C-o> <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]] gj|gk g,|g; zj|zk [z|]z [s|]s zm|zr za|za zc|zo zM|zR zn|zN'
" repeat last f|F and t|T movements via repmo
function! RepmoF(command, mode, count)
	exec "nmap ".g:repmo_key." <Plug>Sneak_;"
	exec "sunmap ".g:repmo_key
	exec "nmap ".g:repmo_revkey." <Plug>Sneak_,"
	exec "sunmap ".g:repmo_revkey
	call feedkeys(a:mode.a:count.a:command)
endfunction
nnoremap <silent> f :<C-u>call RepmoF("\<Plug>Sneak_f", "", v:count1)<CR>
xnoremap <silent> f :<C-u>call RepmoF("\<Plug>Sneak_f", "gv", v:count1)<CR>
nnoremap <silent> F :<C-u>call RepmoF("\<Plug>Sneak_F", "", v:count1)<CR>
xnoremap <silent> F :<C-u>call RepmoF("\<Plug>Sneak_F", "gv", v:count1)<CR>
nnoremap <silent> t :<C-u>call RepmoF("\<Plug>Sneak_t", "", v:count1)<CR>
xnoremap <silent> t :<C-u>call RepmoF("\<Plug>Sneak_t", "gv", v:count1)<CR>
nnoremap <silent> T :<C-u>call RepmoF("\<Plug>Sneak_T", "", v:count1)<CR>
xnoremap <silent> T :<C-u>call RepmoF("\<Plug>Sneak_T", "gv", v:count1)<CR>
nnoremap <silent> s :<C-u>call RepmoF("\<Plug>Sneak_s", "", v:count1)<CR>
xnoremap <silent> s :<C-u>call RepmoF("\<Plug>Sneak_s", "gv", v:count1)<CR>
nnoremap <silent> S :<C-u>call RepmoF("\<Plug>Sneak_S", "", v:count1)<CR>
xnoremap <silent> S :<C-u>call RepmoF("\<Plug>Sneak_S", "gv", v:count1)<CR>

" Restconsole {{{1
command! -nargs=0 Restconsole :packadd rest-console|sp|set ft=rest

" rsi {{{1
let g:rsi_no_meta = 1

" Speeddating {{{1
let g:speeddating_no_mappings = 1
nnoremap <Plug>SpeedDatingFallbackUp <C-a>
nnoremap <Plug>SpeedDatingFallbackDown <C-x>

" Sneak {{{1
" disable sneak mappings in order to integrate them with repmo
nmap <F33>1 <Plug>Sneak_;
omap <F33>1 <Plug>Sneak_;
xmap <F33>1 <Plug>Sneak_;
nmap <F33>2 <Plug>Sneak_,
omap <F33>2 <Plug>Sneak_,
xmap <F33>2 <Plug>Sneak_,
nmap <F33>3 <Plug>Sneak_s
nmap <F33>4 <Plug>Sneak_S

" Swapit {{{1
nmap <silent> <Plug>SwapItFallbackIncrement :<C-u>let sc=v:count1<Bar>packadd speeddating<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>
nmap <silent> <Plug>SwapItFallbackDecrement :<C-u>let sc=v:count1<Bar>packadd speeddating<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>
nmap <silent> <C-a> :<C-u>let swap_count = v:count<Bar>packadd swapit<Bar>call SwapWord(expand("<cword>"), swap_count, 'forward', 'no')<Bar>silent! call repeat#set("\<Plug>SwapIncrement", swap_count)<Bar>unlet swap_count<CR>
nmap <silent> <C-x> :<C-u>let swap_count = v:count<Bar>packadd swapit<Bar>call SwapWord(expand("<cword>"), swap_count, 'backward','no')<Bar>silent! call repeat#set("\<Plug>SwapDecrement", swap_count)<Bar>unlet swap_count<CR>

" thesaurus_query {{{1
let g:tq_map_keys = 1
let g:tq_use_vim_autocomplete = 0
let g:tq_language = ['en', 'de']

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" UltiSnips {{{1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsExpandTrigger = '<C-l>'
let g:UltiSnipsListSnippets = '<C-s>'

" vCooler {{{1
nmap <M-c> :packadd vCoolor<Bar>VCoolor<CR>
imap <M-c> <C-o>:packadd vCoolor<Bar>VCoolor<CR>

" VisIncr {{{1
if exists(':I') != 2
	command! -range -nargs=* I :delc I|delc II|packadd VisIncr|I <args>
	command! -range -nargs=* II :delc I|delc II|packadd VisIncr|II <args>
endif

" XML Ftplugin {{{1
let xml_use_xhtml = 1

" vi: ft=vim:tw=80:sw=4:ts=4:sts=4:et:fdm=marker
