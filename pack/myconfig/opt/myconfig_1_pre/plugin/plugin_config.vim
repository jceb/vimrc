" Plugin Settings

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" General vim plugins {{{1
let g:no_mail_maps = 1

" Colorizer {{{1
let g:colorizer_startup = 0
let g:colorizer_nomap = 1

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

" Completer {{{1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"

" CrefVim {{{1
" don't load cref plugin
let loaded_crefvim = 1

" Current Word {{{1
hi CurrentWordTwins gui=underline cterm=underline
hi link CurrentWord CurrentWordTwins

" Deoplete {{{1
let g:deoplete#enable_at_startup = 1

" Diffwindow Management {{{1
nnoremap ]C :packadd CountJump<CR>:packadd diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :packadd CountJump<CR>:packadd diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

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

" Fuzzy Finder {{{1
" expand the current filenames directory or use the current working directory
function! Expand_file_directory()
       let l:dir = expand('%:p:h')
       if l:dir == ''
               let l:dir = getcwd()
       endif
       let l:dir .= '/'
       return fnameescape(l:dir)
endfunction

let g:fuf_keyNextMode = '<C-l>'
let g:fuf_keyOpenSplit = '<C-s>'
let g:fuf_keyOpenTabpage =  '<C-t>'
let g:fuf_keyOpenVsplit =  '<C-v>'
let g:fuf_keyPrevPattern = '<C-k>'
let g:fuf_keyNextPattern = '<C-j>'

nnoremap <leader>d :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufDir<CR>
nnoremap <leader>D :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufDir <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader><leader> :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufFile<CR>
nnoremap <leader><Bar> :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>v :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufFile ~/.vim/pack/myconfig/<CR>
nnoremap <Bar><Bar> :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>R :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufRenewCache<CR>
nnoremap <leader>B :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufBookmarkDir<CR>
nnoremap <leader>b :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufBuffer<CR>
nnoremap <leader>r :<C-u>packadd l9<CR>:packadd FuzzyFinder<CR>:FufMruFile<CR>
let g:fuf_modesDisable     = [ 'buffers', 'help', 'tag', 'taggedfile', 'quickfix', 'mrucmd', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location = 'botright'
let g:fuf_maxMenuWidth     = 300
let g:fuf_file_exclude     = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight    = 0

" FZF {{{1
let g:fzf_launcher = 'st -e zsh -c %s'
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :Files <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>g :GitFiles<CR>
nnoremap <leader>c :BCommits<CR>
nnoremap <leader>C :Commits<CR>
" nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>L :Lines<CR>
nnoremap <leader>? :Helptags<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>; :Commands<CR>
nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :History/<CR>

" GetLatestVimScripts {{{1
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

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
nnoremap <leader>u :GundoToggle<CR>

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
nmap <leader>k <Plug>InterestingWords
vmap <leader>k <Plug>InterestingWords
nmap <leader>K <Plug>InterestingWordsClear

" LanguageTool {{{1
let g:languagetool_jar=$HOME . '/.vim/pack/vimscripts/opt/LanguageTool/LanguageTool-3.5/languagetool-commandline.jar'
command! -nargs=0 LanguageToolCheck :delc LanguageToolCheck|packadd LanguageTool|LanguageToolCheck

" lightline {{{1
function! LightLineNeomake()
    let l:jobs = neomake#GetJobs()
    if len(l:jobs) > 0
        return len(l:jobs).'⚒'
    endif
    return ''
endfun

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
            \ 'left': [ [ 'neomake', 'mode', 'paste' ],
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

" NeoMake {{{1
let g:neomake_plantuml_plantuml_maker = {
    \ 'args': [],
    \ 'errorformat': '%EError\ line\ %l\ in\ file:\ %f,%Z%m',
    \ }
let g:neomake_plantuml_plantumlsvg_maker = g:neomake_plantuml_plantuml_maker
let g:neomake_plantuml_enabled_makers = ['plantuml', 'plantumlsvg']

" Orgmode {{{1
"let g:org_debug = 1
let g:org_todo_keywords = [['TODO(t)', 'DISCUSSION(D)', 'WAITING(w)', '|', 'DONE(d)'],
			\ ['HIGH(h)', 'MIDDLE(m)', 'LOW(l)']]
let g:org_todo_keyword_faces = [['TODO', [':foreground red', ':background NONE', ':decoration bold']],
			\ ['DISCUSSION', [':foreground darkblue', ':background NONE', ':decoration bold']],
			\ ['WAITING', [':foreground darkyellow', ':background NONE', ':decoration bold']],
			\ ['DONE', [':foreground darkgreen', ':background NONE', ':decoration bold']],
			\ ['HIGH', [':foreground red', ':background NONE', ':decoration bold']],
			\ ['MIDDLE', [':foreground darkyellow', ':background NONE', ':decoration bold']],
			\ ['LOW', [':foreground blue', ':background NONE', ':decoration bold']],
            \ ]

" Python Highlighting {{{1
let python_highlight_all = 1

" python-mode {{{1
let g:pymode_python = 'python3'

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

" rsi {{{1
let g:rsi_no_meta = 1

" Simplenote {{{1
let g:SimplenoteFiletype = "markdown"

" Speeddating {{{1
let g:speeddating_no_mappings = 1
nnoremap <Plug>SpeedDatingFallbackUp <C-a>
nnoremap <Plug>SpeedDatingFallbackDown <C-x>

" Swapit {{{1
nmap <silent> <Plug>SwapItFallbackIncrement :<C-u>let sc=v:count1<CR>:packadd speeddating<CR>:call speeddating#increment(sc)<CR>:unlet sc<CR>
nmap <silent> <Plug>SwapItFallbackDecrement :<C-u>let sc=v:count1<CR>:packadd speeddating<CR>:call speeddating#increment(-sc)<CR>:unlet sc<CR>

" Tagbar {{{1
" convenience shortcut for opening tagbar
nnoremap <Space>t :TagbarToggle<CR>

" thesaurus_query {{{1
let g:tq_map_keys = 0
let g:tq_language = ['en', 'de']
"nnoremap <unique> <leader>cs :ThesaurusQueryReplaceCurrentWord<CR>
"vnoremap <unique> <leader>cs y:Thesaurus <C-r>"<CR>

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" Universal Text Linking {{{1
if $DISPLAY != '' || has('gui_running')
	let g:utl_cfg_hdl_scm_http = "silent !xdg-open '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !x-terminal-emulator -e mutt '%u'"
	for pdfviewer in ['evince', 'okular', 'kpdf', 'acroread']
		" slower implementation but also detect executeables in other locations
		"let pdfviewer = substitute(system('which '.pdfviewer), '\n.*', '', '')
		let pdfviewer = '/usr/bin/'.pdfviewer
		if filereadable(pdfviewer)
			let g:utl_cfg_hdl_mt_application_pdf = 'silent !'.pdfviewer.' "%p"'
			break
		endif
	endfor
else
	let g:utl_cfg_hdl_scm_http = "silent !www-browser '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !mutt '%u'"
	let g:utl_cfg_hdl_mt_application_pdf = 'new|set buftype=nofile|.!pdftotext "%p" -'
endif

" Shortcut to run the Utl command {{{2
" open link
nnoremap gl :packadd utl<CR>:Utl<CR>
xnoremap gl :packadd utl<CR>:Utl o v<CR>
" copy/yank link
nnoremap gL :packadd utl<CR>:Utl cl<CR>
xnoremap gL :packadd utl<CR>:Utl cl v<CR>

" UltiSnips {{{1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsExpandTrigger = '<C-Space>'
let g:UltiSnipsListSnippets = '<C-q>'

" vCoolor
let g:vcoolor_map = 'coo'
let g:vcool_ins_rgb_map = '<Plug>DEAD1'
let g:vcool_ins_hsl_map = '<Plug>DEAD2'

" VisIncr {{{1
if exists(':I') != 2
	command! -range -nargs=* I :delc I|delc II|packadd VisIncr|I <args>
	command! -range -nargs=* II :delc I|delc II|packadd VisIncr|II <args>
endif

" XML Ftplugin {{{1
let xml_use_xhtml = 1

" vi: ft=vim:tw=80:sw=4:ts=4:sts=4:et:fdm=marker