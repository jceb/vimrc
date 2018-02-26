" Plugin Settings

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" General vim plugins {{{1
let g:no_mail_maps = 1

" AutoPairs {{{1
let g:AutoPairsMapSpace = 0

" blinds {{{1
hi Blinds guibg=#cdcdcd

" Characterize {{{1
nmap ga :<C-u>nunmap ga<CR>:packadd characterize<CR><Plug>(characterize)

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
nnoremap ]C :<C-u>packadd CountJump<CR>:packadd diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :<C-u>packadd CountJump<CR>:packadd diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

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

" Fugitive {{{1
autocmd BufReadPost fugitive://* set bufhidden=delete

" FZF {{{1
" expand the current filenames directory or use the current working directory
function! Expand_file_directory()
       let l:dir = expand('%:p:h')
       if l:dir == ''
               let l:dir = getcwd()
       endif
       let l:dir .= '/'
       return fnameescape(l:dir)
endfunction

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~25%' }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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
let g:languagetool_jar=$HOME . '/.vim/pack/vimscripts/opt/LanguageTool/LanguageTool-3.5/languagetool-commandline.jar'
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
            \ 'left': [ [ 'mode', 'paste' ],
            \           [ 'bomb', 'diff', 'scrollbind', 'noeol', 'readonly', 'fugitive', 'filename', 'modified' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ],
            \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'inactive' : {
            \ 'left': [ [ 'diff', 'scrollbind', 'filename', 'modified' ] ],
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
let g:PaperColor_Theme_Options = {
            \ 'theme': {
            \   'default.light': {
            \     'transparent_background': 0,
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
let g:pymode_lint_ignore = "E501,W191"
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']

" Repmo {{{1
let g:repmo_key    = ';'
let g:repmo_revkey = ','
" don't map hjkl to speed up navigation since I tend forget to use repmo for these movements
" removed n|N - keys generate an error message when nothing is found which is very annoying
let g:repmo_mapmotions = '<C-i>|<C-o> <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]] gj|gk g,|g; zj|zk [z|]z [s|]s zm|zr za|za zc|zo zM|zR zn|zN'
if has('gui_running')
    let g:repmo_mapmotions = '<C-i>|<C-o> ' . g:repmo_mapmotions
endif
" repeat last f|F and t|T movements via repmo
function! RepmoF(command, mode, count)
	let l:key = nr2char(getchar())

	" stop when escape was hit
	if l:key == ''
		return
	endif
	exec "noremap ".g:repmo_key." ".a:count.";"
	exec "sunmap ".g:repmo_key
	exec "noremap ".g:repmo_revkey." ".a:count.","
	exec "sunmap ".g:repmo_revkey
	call feedkeys(a:mode.a:count.a:command.l:key, 'n')
endfunction
nnoremap <silent> f :<C-u>call RepmoF("f", "", v:count1)<CR>
xnoremap <silent> f :<C-u>call RepmoF("f", "gv", v:count1)<CR>
nnoremap <silent> F :<C-u>call RepmoF("F", "", v:count1)<CR>
xnoremap <silent> F :<C-u>call RepmoF("F", "gv", v:count1)<CR>
nnoremap <silent> t :<C-u>call RepmoF("t", "", v:count1)<CR>
xnoremap <silent> t :<C-u>call RepmoF("t", "gv", v:count1)<CR>
nnoremap <silent> T :<C-u>call RepmoF("T", "", v:count1)<CR>
xnoremap <silent> T :<C-u>call RepmoF("T", "gv", v:count1)<CR>

" Restconsole {{{1
command! -nargs=0 Restconsole :packadd rest-console|sp|set ft=rest

" rsi {{{1
let g:rsi_no_meta = 1

" Speeddating {{{1
let g:speeddating_no_mappings = 1
nnoremap <Plug>SpeedDatingFallbackUp <C-a>
nnoremap <Plug>SpeedDatingFallbackDown <C-x>

" Swapit {{{1
nmap <silent> <Plug>SwapItFallbackIncrement :<C-u>let sc=v:count1<CR>:packadd speeddating<CR>:call speeddating#increment(sc)<CR>:unlet sc<CR>
nmap <silent> <Plug>SwapItFallbackDecrement :<C-u>let sc=v:count1<CR>:packadd speeddating<CR>:call speeddating#increment(-sc)<CR>:unlet sc<CR>
nmap <silent> <C-a> :<C-u>let swap_count = v:count<CR>:packadd swapit<CR>:call SwapWord(expand("<cword>"), swap_count, 'forward', 'no')<CR>:silent! call repeat#set("\<Plug>SwapIncrement", swap_count)<CR>:unlet swap_count<CR>
nmap <silent> <C-x> :<C-u>let swap_count = v:count<CR>:packadd swapit<CR>:call SwapWord(expand("<cword>"), swap_count, 'backward','no')<CR>:silent! call repeat#set("\<Plug>SwapDecrement", swap_count)<CR>:unlet swap_count<CR>

" thesaurus_query {{{1
let g:tq_map_keys = 1
let g:tq_use_vim_autocompletefunc = 1
let g:tq_language = ['en', 'de']

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" UltiSnips {{{1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsExpandTrigger = '<C-y>'
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
