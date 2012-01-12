" Plugin Settings:

" ------------------------------------------------------------
" Buffergator:
let g:buffergator_viewport_split_policy = 'B'
let g:buffergator_autoexpand_on_split = 0
let g:buffergator_suppress_keymaps = '1'
let g:buffergator_split_size = 10
nnoremap <silent> <Leader>b :IP buffergator<CR>:BuffergatorToggle<CR>
nnoremap <silent> <Leader>B :IP buffergator<CR>:BuffergatorTabsToggle<CR>

" ------------------------------------------------------------
" Bufkill:
nmap <Plug>NotUsedBufKillBack    <Plug>BufKillBack
nmap <Plug>NotUsedBufKillForward <Plug>BufKillForward
nmap <Plug>NotUsedBufKillBun     <Plug>BufKillBun
nmap <Plug>NotUsedBufKillBangBun <Plug>BufKillBangBun
nmap <Plug>NotUsedBufKillBd      <Plug>BufKillBd
nmap <Plug>NotUsedBufKillBangBd  <Plug>BufKillBangBd
nmap <Plug>NotUsedBufKillBw      <Plug>BufKillBw
nmap <Plug>NotUsedBufKillBangBw  <Plug>BufKillBangBw
nmap <Plug>NotUsedBufKillUndo    <Plug>BufKillUndo
nmap <Plug>NotUsedBufKillAlt     <Plug>BufKillAlt

" ------------------------------------------------------------
" Chapa:
"let g:chapa_default_mappings = 1
" Function Movement
nmap fnf <Plug>ChapaNextFunction
nmap fpf <Plug>ChapaPreviousFunction

" Class Movement
nmap fnc <Plug>ChapaNextClass
nmap fpc <Plug>ChapaPreviousClass

" Method Movement
nmap fnm <Plug>ChapaNextMethod
nmap fpm <Plug>ChapaPreviousMethod

" Class Visual Select
nmap vnc <Plug>ChapaVisualNextClass
nmap vic <Plug>ChapaVisualThisClass
nmap vpc <Plug>ChapaVisualPreviousClass

" Method Visual Select
nmap vnm <Plug>ChapaVisualNextMethod
nmap vim <Plug>ChapaVisualThisMethod
nmap vpm <Plug>ChapaVisualPreviousMethod

" Function Visual Select
nmap vnf <Plug>ChapaVisualNextFunction
nmap vif <Plug>ChapaVisualThisFunction
nmap vpf <Plug>ChapaVisualPreviousFunction

" Comment Class
nmap cnc <Plug>ChapaCommentNextClass
nmap cic <Plug>ChapaCommentThisClass
nmap cpc <Plug>ChapaCommentPreviousClass

" Comment Method
nmap cnm <Plug>ChapaCommentNextMethod
nmap cim <Plug>ChapaCommentThisMethod
nmap cpm <Plug>ChapaCommentPreviousMethod

" Comment Function
nmap cif <Plug>ChapaCommentThisFunction
nmap cnf <Plug>ChapaCommentNextFunction
nmap cpf <Plug>ChapaCommentPreviousFunction

" Repeat Mappings
nmap <C-h> <Plug>ChapaOppositeRepeat
nmap <C-l> <Plug>ChapaRepeat

" Folding Method
nmap znm <Plug>ChapaFoldNextMethod
nmap zim <Plug>ChapaFoldThisMethod
nmap zpm <Plug>ChapaFoldPreviousMethod

" Folding Class
nmap znc <Plug>ChapaFoldNextClass
nmap zic <Plug>ChapaFoldThisClass
nmap zpc <Plug>ChapaFoldPreviousClass

" Folding Function
nmap znf <Plug>ChapaFoldNextFunction
nmap zif <Plug>ChapaFoldThisFunction
nmap zpf <Plug>ChapaFoldPreviousFunction

" ------------------------------------------------------------
" Colorizer:
nmap <leader>c <Plug>Colorizer

" ------------------------------------------------------------
" CrefVim:
" don't load cref plugin
let loaded_crefvim = 1

" ------------------------------------------------------------
" Dict:
" disable dict
let g:loaded_dict = 1
" ------------------------------------------------------------
" EasyMotion:
let g:EasyMotion_target_hl = "Error"

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
let g:fuf_modesDisable = [ 'buffer', 'help', 'bookmark', 'tag', 'taggedfile', 'quickfix', 'mrucmd', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location  = 'botright'
let g:fuf_maxMenuWidth = 300
let g:fuf_file_exclude = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight = 0

" ------------------------------------------------------------
" GetLatestVimScripts:
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" ------------------------------------------------------------
" Gundo:
nnoremap <leader>u :silent! IP gundo<CR>:GundoToggle<CR>

" ------------------------------------------------------------
" Hier:
" disable highlighting for location list entries
let g:hier_highlight_group_loc  = ''
let g:hier_highlight_group_locw = ''
let g:hier_highlight_group_loci = ''

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
" Netrw:
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" ------------------------------------------------------------
" NERD Commenter:
" no default mappings
let g:NERDCreateDefaultMappings = 0
" toggle comment
nmap <leader><space> <plug>NERDCommenterToggle
vmap <leader><space> <plug>NERDCommenterToggle

" insert current comment leader in insert mode
inoremap <C-c> <C-o>:call NERDComment(0, "insert")<CR>

" ------------------------------------------------------------
" NERDTree:
nnoremap <leader>e :silent! IP NERDtree<CR>:NERDTreeToggle<CR>
nnoremap <leader>E :silent! IP NERDtree<CR>:NERDTreeFind<CR>
" integrate with cdargs
let g:NERDTreeBookmarksFile = $HOME.g:sep.'.cdargs'
let g:NERDTreeIgnore = ['\.pyc$', '\~$']

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
" Python Highlighting:
let python_highlight_all = 1

" ------------------------------------------------------------
" Repmo:
"let g:repmo_revkey = '<CR>'

" ------------------------------------------------------------
" Supertab:
let g:SuperTabDefaultCompletionType = "<c-n>"

" ------------------------------------------------------------
" Tagbar:
" convenience shortcut for opening tagbar
nnoremap <leader>t :silent! IP tagbar<CR>:TagbarOpen<CR>

" ------------------------------------------------------------
" TagList:
let Tlist_Sort_Type = "order"
let Tlist_Show_One_File = 1

" ------------------------------------------------------------
" ToHTML:
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" ------------------------------------------------------------
" Transpose Words:
nmap <unique> gxp <Plug>Transposewords
imap <unique> <M-t> <Plug>Transposewords
cmap <unique> <M-t> <Plug>Transposewords

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
" XML Ftplugin:
let xml_use_xhtml = 1

" ------------------------------------------------------------
" YankRing:
nnoremap <silent> <F8> :YRShow<CR>

let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
" remove Y from the yankring list because Y is a broken keybinding which got
" replaced by y$
let g:yankring_n_keys = 'D x X'
let g:yankring_history_file = '.yankring_history_file'
let g:yankring_map_dot = 0
