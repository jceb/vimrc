" Plugin Settings:

" ------------------------------------------------------------
" Clam:
if exists(":Clam") != 2
	command -nargs=+ -complete=shellcmd Clam :delc Clam|silent! exec "IP clam"|Clam <args>
endif
nnoremap <leader>r :Clam 

" ------------------------------------------------------------
" Colorizer:
nmap <leader>c :ColorToggle<CR>
command -nargs=0 ColorToggle :delc ColorToggle|silent! exec "IP colorizer"|ColorToggle

" ------------------------------------------------------------
" Commentary:
function! InsertCommentstring()
  let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
  let col = col('.') - 1
  let line = line('.')
  let line_text = getline('.')
  call setline(line, line_text[0:col - 1] . l . r . line_text[col :-1])
  call cursor(line, col + strlen(l) + 1)
endfunction
inoremap <C-c> <C-o>:call InsertCommentstring()<CR>

" ------------------------------------------------------------
" CrefVim:
" don't load cref plugin
let loaded_crefvim = 1

" ------------------------------------------------------------
" Diffwindow Management:
nnoremap ]C :silent! IP CountJump diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, 1, 1, 0)<CR>
nnoremap [C :silent! IP CountJump diffwindow_movement<CR>:call CountJump#JumpFunc('n', 'CountJump#Region#JumpToNextRegion', function('diffwindow_movement#IsDiffLine'), 1, -1, 0, 0)<CR>

" ------------------------------------------------------------
" Editqf:
command -nargs=0 Copen :delc Copen|silent! exec "IP editqf"|copen

" ------------------------------------------------------------
" Fastwordcompleter:
let g:fastwordcompletion_min_length = 3
"let g:fastwordcompleter_filetypes = '*'
let g:fastwordcompleter_filetypes = 'asciidoc,mkd,txt,mail,help'

" ------------------------------------------------------------
" Fugitive:
autocmd BufReadPost fugitive://* set bufhidden=delete

" ------------------------------------------------------------
" GetLatestVimScripts:
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" ------------------------------------------------------------
" Gundo:
if exists(":GundoToggle") != 2
	command -nargs=0 GundoToggle :delc GundoToggle|silent! exec "IP gundo"|GundoToggle
endif
nnoremap <leader>u :GundoToggle<CR>

" ------------------------------------------------------------
" Hier:
" disable highlighting for location list entries
let g:hier_highlight_group_loc  = ''
let g:hier_highlight_group_locw = ''
let g:hier_highlight_group_loci = ''

if exists(":HierUpdate") != 2
	command -nargs=0 HierStart :delc HierUpdate|delc HierStart|silent! exec "IP hier"|HierStart
	command -nargs=0 HierUpdate :delc HierUpdate|delc HierStart|silent! exec "IP hier"|HierUpdate
endif

" ------------------------------------------------------------
" IPI:
nnoremap <leader>i :IP <C-Z>

" ------------------------------------------------------------
" LanguageTool:
let g:languagetool_jar=$HOME . '/.vim/ipi/LanguageTool/LanguageTool/LanguageTool.jar'
command -nargs=0 LanguageToolCheck :delc LanguageToolCheck|silent! exec "IP LanguageTool"|LanguageToolCheck

" ------------------------------------------------------------
" Lucius:
let g:lucius_style='light'

" ------------------------------------------------------------
" Lusty:
let g:LustyExplorerSuppressRubyWarning = 1
let g:LustyExplorerDefaultMappings = 0

nnoremap <leader>f :LustyFilesystemExplorer<CR>
nnoremap <leader>F :LustyFilesystemExplorerFromHere<CR>
nnoremap <leader>b :LustyBufferExplorer<CR>
nnoremap <leader>g :LustyBufferGrep<CR>
command -nargs=? LustyFilesystemExplorer :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec "IP lusty"|LustyFilesystemExplorer <args>
command -nargs=0 LustyFilesystemExplorerFromHere :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec "IP lusty"|LustyFilesystemExplorerFromHere
command -nargs=0 LustyBufferExplorer :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec "IP lusty"|LustyBufferExplorer
command -nargs=0 LustyBufferGrep :delc LustyFilesystemExplorer|delc LustyFilesystemExplorerFromHere|delc LustyBufferExplorer|delc LustyBufferGrep|silent! exec "IP lusty"|LustyBufferGrep

" ------------------------------------------------------------
" Man:
" load manpage-plugin
"runtime! ftplugin/man.vim
" cut startup time dramatically by loading the man plugin on demand
if exists(":Man") != 2
	command -nargs=+ Man :delc Man|runtime! ftplugin/man.vim|Man <args>
endif

" ------------------------------------------------------------
" NarrowRegion:
if exists(":NarrowRegion") != 2
	command -range -nargs=0 NarrowRegion :delc NarrowRegion|silent! exec "IP NarrowRegion"|<line1>,<line2>NarrowRegion
endif
vnoremap <leader>nr :NarrowRegion<CR>

" ------------------------------------------------------------
" Netrw:
" hide dotfiles by default - the gh mapping quickly changes this behavior

" ------------------------------------------------------------
" Orgmode:
"let g:org_debug = 1
let g:org_todo_keywords = [['TODO(t)', 'WAITING(w)', '|', 'DONE(d)'],
			\ ['IMPLEMENTATION(i)', 'DRAFT(r)', 'REOPEN(o)', 'QA(q)', '|', 'VERIFIED(v)']]
let g:org_todo_keyword_faces = [['TODO', [':foreground red', ':background NONE', ':decoration bold']],
			\ ['WAITING', [':foreground darkyellow', ':background NONE', ':decoration bold']],
			\ ['DONE', [':foreground darkgreen', ':background NONE', ':decoration bold']],
			\ ['QA', [':foreground darkyellow', ':background NONE', ':decoration bold']]]

" ------------------------------------------------------------
" PEP8:
let g:pep8_options = '--ignore=W191,E501'

" ------------------------------------------------------------
" Python Highlighting:
let python_highlight_all = 1

" ------------------------------------------------------------
" Rename:
if exists(":Rename") != 2
	command -bang -nargs=* -complete=file Rename :delc Rename|silent! exec ":IP rename"|Rename<bang> <args>
endif

" ------------------------------------------------------------
" Repmo:
let g:repmo_key    = '<Space>'
let g:repmo_revkey = '<S-Space>'
let g:repmo_mapmotions = "j|k h|l <C-e>|<C-y> <C-d>|<C-u> <C-f>|<C-b> zh|zl w|b W|B e|ge E|gE (|) {|} [[|]] g,|g;"

" ------------------------------------------------------------
" Session:
if exists(":OpenSession") != 2
	command -bang -nargs=? OpenSession :delc OpenSession|delc SaveSession|silent! exec "IP session"|OpenSession <args>
	command -bang -nargs=? SaveSession :delc OpenSession|delc SaveSession|silent! exec "IP session"|SaveSession <args>
endif
let g:session_directory = fnameescape($HOME.g:sep.'.cache'.g:sep.'vim'.g:sep.'sessions')

" ------------------------------------------------------------
" Speeddating:
if exists(":SpeedDatingFormat") != 2
	nnoremap <silent> <C-a> :silent! IP speeddating<CR>:call feedkeys('<C-a>')<CR>
	nnoremap <silent> <C-x> :silent! IP speeddating<CR>:call feedkeys('<C-x>')<CR>
endif

" ------------------------------------------------------------
" Supertab:
let g:SuperTabDefaultCompletionType = "<c-n>"

" ------------------------------------------------------------
" SudoEdit:
if exists(":SudoWrite") != 2
	command -bang -nargs=? -complete=file SudoRead :delc SudoWrite|delc SudoRead|silent! exec ":IP SudoEdit"|SudoRead<bang> <args>
	command -range -bang -nargs=? -complete=file SudoWrite :delc SudoWrite|delc SudoRead|silent! exec ":IP SudoEdit"|SudoWrite<bang> <args>
endif

" ------------------------------------------------------------
" Tabular:
if exists(":Tabularize") != 2
	command -range -nargs=+ Tabularize :delc Tabularize|silent! exec "IP tabular"|<line1>,<line2>Tabularize <args>
endif
vnoremap <leader>t :Tabularize /

" ------------------------------------------------------------
" Tagbar:
" convenience shortcut for opening tagbar
if exists(":TagbarOpen") != 2
	command -nargs=0 TagbarOpen :delc TagbarOpen|delc TagbarToggle|silent! exec ":IP tagbar"|TagbarOpen
	command -nargs=0 TagbarToggle :delc TagbarOpen|delc TagbarToggle|silent! exec ":IP tagbar"|TagbarToggle
endif
nnoremap <leader>t :TagbarToggle<CR>

" ------------------------------------------------------------
" ToHTML:
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" ------------------------------------------------------------
" Txtbrowser:
" don't load the plugin cause it's not helpful for my workflow
" id=txtbrowser_disabled
let g:txtbrowser_version = "don't load!"

" ------------------------------------------------------------
" Txtfmt:
" disable map warnings and overwrite any conflicts
let g:txtfmtMapwarn = "cC"

" ------------------------------------------------------------
" Universal Text Linking:
if $DISPLAY != "" || has('gui_running')
	let g:utl_cfg_hdl_scm_http = "silent !x-www-browser '%u' &"
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

" Shortcut to run the Utl command
" open link
nnoremap gl :silent! IP utl<CR>:Utl<CR>
vnoremap gl :silent! IP utl<CR>:Utl o v<CR>
" copy/yank link
nnoremap gL :silent! IP utl<CR>:Utl cl<CR>
vnoremap gL :silent! IP utl<CR>:Utl cl v<CR>

" ------------------------------------------------------------
" UltiSnips:
let g:UltiSnipsRemoveSelectModeMappings = 0

" ------------------------------------------------------------
" VisIncr:
if exists(":I") != 2
	command -range -nargs=* I :delc I|delc II|silent! exec "IP VisIncr"|I <args>
	command -range -nargs=* II :delc I|delc II|silent! exec "IP VisIncr"|II <args>
endif

" ------------------------------------------------------------
" XML Ftplugin:
let xml_use_xhtml = 1
