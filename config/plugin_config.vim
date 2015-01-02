" Plugin Settings

" Airline {{{1
" let g:airline_left_sep  = ''
" let g:airline_right_sep = ''
let g:airline_theme     = 'simple'
let g:airline_powerline_fonts = 1

" Brightest {{{1
" disable highlighting for certain file types
let g:brightest#enable_filetypes = {
			\   "asciidoc"   : 0,
			\   "cg"   : 0,
			\   "debchangelog"   : 0,
			\   "docbk"   : 0,
			\   "gitcommit"   : 0,
			\   "help"   : 0,
			\   "hg"   : 0,
			\   "html"   : 0,
			\   "mail"   : 0,
			\   "markdown"   : 0,
			\   "org"   : 0,
			\   "plaintex"   : 0,
			\   "tex"   : 0,
			\   "txt"   : 0,
			\   "xml"   : 0,
			\}
let g:brightest#highlight = {
			\   "group" : "BrightestUnderline",
			\}

" AutoComplPop
" imap <Tab> <C-n>
" imap <S-Tab> <C-p>
function! GetSnipsInCurrentScope()
  return UltiSnips#SnippetsInCurrentScope()
endfunction
let g:acp_behaviorSnipmateLength = 1

" Clam {{{1
if exists(':Clam') != 2
	command -nargs=+ -complete=shellcmd Clam :delc Clam|silent! exec 'IP clam'|Clam <args>
endif
nnoremap <leader>r :Clam 

" Coloresque {{{1
command Coloresque silent! exec 'IP! coloresque'|syn include syntax/css/vim-coloresque.vim

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

" CrefVim {{{1
" don't load cref plugin
let loaded_crefvim = 1

" Diffwindow Management {{{1
nnoremap ]C :silent! IP CountJump diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :silent! IP CountJump diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

" Easyclip
let g:EasyClipUseCutDefaults = 0
let g:EasyClipYankHistorySize = 20
let g:EasyClipEnableBlackHoleRedirect = 0
let g:EasyClipUseSubstituteDefaults = 0
nmap grr <Plug>SubstituteLine
nmap gR <Plug>SubstituteToEndOfLine
nmap gr <Plug>SubstituteOverMotionMap

" Fastwordcompleter {{{1
let g:fastwordcompletion_min_length = 3
"let g:fastwordcompleter_filetypes = '*'
let g:fastwordcompleter_filetypes = 'asciidoc,mkd,txt,mail,help'

" Fugitive {{{1
autocmd BufReadPost fugitive://* set bufhidden=delete

" Fuzzy Finder {{{1
" expand the current filenames directory or use the current working directory
function! Expand_file_directory()
       let dir = expand('%:~:.:h')
       if dir == ''
               let dir = getcwd()
       endif
       let dir .= '/'
       return dir
endfunction

let g:fuf_keyNextMode = '<C-l>'
let g:fuf_keyOpenSplit = '<C-j>'
let g:fuf_keyOpenTabpage =  '<C-t>'
let g:fuf_keyOpenVsplit =  '<C-v>'

nnoremap <leader>d :silent! IP l9 FuzzyFinder<CR>:FufDir<CR>
nnoremap <leader>D :silent! IP l9 FuzzyFinder<CR>:FufDir <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>f :silent! IP l9 FuzzyFinder<CR>:FufFile<CR>
nnoremap <leader>F :silent! IP l9 FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>R :silent! IP l9 FuzzyFinder<CR>:FufRenewCache<CR>
nnoremap <leader>m :silent! IP l9 FuzzyFinder<CR>:FufBookmarkDir<CR>
nnoremap <leader>b :silent! IP l9 FuzzyFinder<CR>:FufBuffer<CR>
let g:fuf_modesDisable     = [ 'help', 'tag', 'taggedfile', 'quickfix', 'mrucmd', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location = 'botright'
let g:fuf_maxMenuWidth     = 300
let g:fuf_file_exclude     = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight    = 0

" FZF {{{1
let g:fzf_launcher = 'st -e zsh -c %s'
" let g:fzf_root_markers = ['.git', 'debian']
nnoremap <leader>p :FZF<CR>
" nnoremap <leader>P :FZFRoot<CR>

" GetLatestVimScripts {{{1
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" Gundo {{{1
if exists(':GundoToggle') != 2
	command -nargs=0 GundoToggle :delc GundoToggle|silent! exec 'IP gundo'|GundoToggle
endif
nnoremap <leader>u :GundoToggle<CR>

" Hier {{{1
" disable highlighting for location list entries
let g:hier_highlight_group_loc  = ''
let g:hier_highlight_group_locw = ''
let g:hier_highlight_group_loci = ''

if exists(':HierUpdate') != 2
	command -nargs=0 HierStart :delc HierUpdate|delc HierStart|silent! exec 'IP hier'|HierStart
	command -nargs=0 HierUpdate :delc HierUpdate|delc HierStart|silent! exec 'IP hier'|HierUpdate
endif

" IPI {{{1
nnoremap <leader>i :IP <C-Z>

" LanguageTool {{{1
let g:languagetool_jar=$HOME . '/.vim/ipi/LanguageTool/LanguageTool/LanguageTool.jar'
command -nargs=0 LanguageToolCheck :delc LanguageToolCheck|silent! exec 'IP LanguageTool'|LanguageToolCheck

" Lucius {{{1
let g:lucius_style='light'

" Lusty {{{1
let g:LustyExplorerSuppressRubyWarning = 1
let g:LustyExplorerDefaultMappings = 0

" nnoremap <leader>f :LustyFilesystemExplorer<CR>
" nnoremap <leader>F :LustyFilesystemExplorerFromHere<CR>
" nnoremap <leader>b :LustyBufferExplorer<CR>
" nnoremap <leader>g :LustyBufferGrep<CR>
command -nargs=? LustyFilesystemExplorer :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec 'IP lusty'|LustyFilesystemExplorer <args>
command -nargs=0 LustyFilesystemExplorerFromHere :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec 'IP lusty'|LustyFilesystemExplorerFromHere
command -nargs=0 LustyBufferExplorer :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec 'IP lusty'|LustyBufferExplorer
command -nargs=0 LustyBufferGrep :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec 'IP lusty'|LustyBufferGrep

" Man {{{1
" load manpage-plugin
"runtime! ftplugin/man.vim
" cut startup time dramatically by loading the man plugin on demand
if exists(':Man') != 2
	command -nargs=+ Man :delc Man|runtime! ftplugin/man.vim|Man <args>
endif

" Netrw {{{1
" hide dotfiles by default - the gh mapping quickly changes this behavior

" Orgmode {{{1
"let g:org_debug = 1
let g:org_todo_keywords = [['TODO(t)', 'DISCUSSION(D)', 'WAITING(w)', '|', 'DONE(d)'],
			\ ['IMPLEMENTATION(i)', 'DRAFT(r)', 'REOPEN(o)', 'QA(q)', '|', 'VERIFIED(v)']]
let g:org_todo_keyword_faces = [['TODO', [':foreground red', ':background NONE', ':decoration bold']],
			\ ['DISCUSSION', [':foreground darkblue', ':background NONE', ':decoration bold']],
			\ ['WAITING', [':foreground darkyellow', ':background NONE', ':decoration bold']],
			\ ['DONE', [':foreground darkgreen', ':background NONE', ':decoration bold']],
			\ ['QA', [':foreground darkyellow', ':background NONE', ':decoration bold']]]

" PEP8 {{{1
let g:pep8_options = '--ignore=W191,E501'

" Python Highlighting {{{1
let python_highlight_all = 1

" QuickBuf {{{1
let g:qb_hotkey = '<leader>b'

" Rename {{{1
if exists(':Rename') != 2
	command -bang -nargs=* -complete=file Rename :delc Rename|silent! exec ':IP rename'|Rename<bang> <args>
endif

" Repmo {{{1
let g:repmo_key    = '<Space>'
let g:repmo_revkey = '<BS>'
let g:repmo_mapmotions = 'j|k h|l <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]] g,|g; zj|zk [z|]z'

" Session {{{1
let g:session_directory = fnameescape($HOME.g:sep.'.cache'.g:sep.'vim'.g:sep.'sessions')
let g:session_autoload = 'no'

" Speeddating {{{1
if exists(':SpeedDatingFormat') != 2
	nnoremap <silent> <C-a> :<C-u>silent! let b:vc=v:count1<CR>:IP speeddating<CR>:call feedkeys(b:vc.'<C-a>')<CR>:unlet b:vc<CR>
	nnoremap <silent> <C-x> :<C-u>silent! let b:vc=v:count1<CR>:IP speeddating<CR>:call feedkeys(b:vc.'<C-x>')<CR>:unlet b:vc<CR>
endif

" Tabular {{{1
if exists(':Tabularize') != 2
	command -range -nargs=+ Tabularize :delc Tabularize|silent! exec 'IP tabular'|<line1>,<line2>Tabularize <args>
endif
xnoremap <leader>t :Tabularize /

" Tagbar {{{1
" convenience shortcut for opening tagbar
if exists(':TagbarOpen') != 2
	command -nargs=0 TagbarOpen :delc TagbarOpen|delc TagbarToggle|silent! exec ':IP tagbar'|TagbarOpen
	command -nargs=0 TagbarToggle :delc TagbarOpen|delc TagbarToggle|silent! exec ':IP tagbar'|TagbarToggle
endif
nnoremap <leader>t :TagbarToggle<CR>

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" Txtbrowser {{{1
" don't load the plugin cause it's not helpful for my workflow
" id=txtbrowser_disabled
let g:txtbrowser_version = "don't load!"

" Txtfmt {{{1
" disable map warnings and overwrite any conflictk
let g:txtfmtMapwarn = 'cC'

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

" Shortcut to run the Utl command {{{1
" open link
nnoremap gl :silent! IP utl<CR>:Utl<CR>
xnoremap gl :silent! IP utl<CR>:Utl o v<CR>
" copy/yank link
nnoremap gL :silent! IP utl<CR>:Utl cl<CR>
xnoremap gL :silent! IP utl<CR>:Utl cl v<CR>

" Syntastic {{{1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_flake8_quiet_messages = {'regex': '\V\([W191]\|[E501]\)'}
let g:syntastic_python_pep8_quiet_messages = g:syntastic_python_flake8_quiet_messages

" UltiSnips {{{1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsExpandTrigger = '<C-y>'
let g:UltiSnipsListSnippets = '<C-b>'

" vCoolor
let g:vcoolor_map = 'coo'
let g:vcool_ins_rgb_map = '<Plug>DEAD1'
let g:vcool_ins_hsl_map = '<Plug>DEAD2'

" VisIncr {{{1
if exists(':I') != 2
	command -range -nargs=* I :delc I|delc II|silent! exec 'IP VisIncr'|I <args>
	command -range -nargs=* II :delc I|delc II|silent! exec 'IP VisIncr'|II <args>
endif

" XML Ftplugin {{{1
let xml_use_xhtml = 1
"
" YouCompleteMe {{{1
let g:ycm_filetype_blacklist = {
			\ 'tagbar' : 1,
			\ 'qf' : 1,
			\ 'notes' : 1,
			\ 'unite' : 1,
			\}

" vi: ft=vim:tw=0:sw=4:ts=4:fdm=marker
