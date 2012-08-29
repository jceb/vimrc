" Plugin Settings:

" ------------------------------------------------------------
" Buffet:
nnoremap <silent> <Leader>b :IP buffet<CR>:Bufferlist<CR>

" ------------------------------------------------------------
" Clam:
if exists(":Clam") != 2
	command -nargs=+ Clam :delc Clam|silent! exec "IP clam"|Clam <args>
endif
nnoremap <leader>r :Clam 

" ------------------------------------------------------------
" Colorizer:
nmap <leader>c :ColorToggle<CR>
command -nargs=0 ColorToggle :delc ColorToggle|silent! exec "IP colorizer"|ColorToggle

" ------------------------------------------------------------
" CrefVim:
" don't load cref plugin
let loaded_crefvim = 1

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
" FuzzyFinder:
" expand the current filenames directory or use the current working directory
function! Expand_file_directory()
	let dir = expand('%:~:.:h')
	if dir == ''
		let dir = getcwd()
	endif
	let dir .= '/'
	return dir
endfunction

nnoremap <leader>d :silent! IP l9 FuzzyFinder<CR>:FufDir<CR>
nnoremap <leader>D :silent! IP l9 FuzzyFinder<CR>:FufDir <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>f :silent! IP l9 FuzzyFinder<CR>:FufFile<CR>
nnoremap <leader>F :silent! IP l9 FuzzyFinder<CR>:FufFile <C-r>=Expand_file_directory()<CR><CR>
nnoremap <leader>R :silent! IP l9 FuzzyFinder<CR>:FufRenewCache<CR>
let g:fuf_modesDisable     = [ 'buffer', 'help', 'bookmark', 'tag', 'taggedfile', 'quickfix', 'mrucmd', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location = 'botright'
let g:fuf_maxMenuWidth     = 300
let g:fuf_file_exclude     = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight    = 0

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
let g:languagetool_jar=$HOME . '/.vim/bundle/LanguageTool/LanguageTool.jar'

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
" NERDCommenter:
" no default mappings
let g:NERDCreateDefaultMappings = 0
" toggle comment
nmap <leader><space> <plug>NERDCommenterToggle
vmap <leader><space> <plug>NERDCommenterToggle
inoremap <C-c> <C-o>:call NERDComment(0, "insert")<CR>

" ------------------------------------------------------------
" NERDTree:
nnoremap <leader>e :silent! IP NERDtree<CR>:NERDTreeToggle<CR>
nnoremap <leader>E :silent! IP NERDtree<CR>:NERDTreeFind<CR>
" integrate with cdargs
let g:NERDTreeBookmarksFile = $HOME.g:sep.'.cdargs'
let g:NERDTreeIgnore = ['\.pyc$', '\~$']

" ------------------------------------------------------------
" Netrw:
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

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
" Pydoc:
if exists(":Pydoc") != 2
	command -nargs=1 Pydoc :delc Pydoc|delc PydocSearch|silent! exec "IP pydoc910"|Pydoc <args>
	command -nargs=* PydocSearch :delc Pydoc|delc PydocSearch|silent! exec "IP pydoc910"|PydocSearch <args>
endif

" ------------------------------------------------------------
" Python Highlighting:
let python_highlight_all = 1

" ------------------------------------------------------------
" Rename:
if exists(":Rename") != 2
	command -bang -nargs=+ Rename :delc Rename|silent! exec ":IP rename"|Rename<bang> <args>
endif

" ------------------------------------------------------------
" Repmo:
let g:repmo_key    = '<Space>'
let g:repmo_revkey = '<S-Space>'

" ------------------------------------------------------------
" Session:
if exists(":OpenSession") != 2
	command -bang -nargs=? OpenSession :delc OpenSession|delc SaveSession|silent! exec "IP session"|OpenSession <args>
	command -bang -nargs=? SaveSession :delc OpenSession|delc SaveSession|silent! exec "IP session"|SaveSession <args>
endif
let g:session_directory = fnameescape(g:vimdir.g:sep.'.tmp'.g:sep.'sessions')

" ------------------------------------------------------------
" Supertab:
let g:SuperTabDefaultCompletionType = "<c-n>"

" ------------------------------------------------------------
" SudoEdit:
if exists(":SudoWrite") != 2
	command -bang -nargs=? SudoRead :delc SudoWrite|delc SudoRead|silent! exec ":IP SudoEdit"|SudoRead<bang> <args>
	command -range -bang -nargs=? SudoWrite :delc SudoWrite|delc SudoRead|silent! exec ":IP SudoEdit"|SudoWrite<bang> <args>
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
" Transpose Words:
nmap <unique> gxp :silent! IP transword<CR><Plug>Transposewords
imap <unique> <M-t> :silent! IP transword<CR><Plug>Transposewords
cmap <unique> <M-t> :silent! IP transword<CR><Plug>Transposewords

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
nnoremap gyl :silent! IP utl<CR>:Utl cl<CR>
vnoremap gyl :silent! IP utl<CR>:Utl cl v<CR>

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
