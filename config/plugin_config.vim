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
nmap <leader>c :silent! IP colorizer<CR><Plug>Colorizer

" ------------------------------------------------------------
" Commentary:
xmap <leader><leader> <Plug>Commentary
nmap <leader><leader> <Plug>Commentary
nmap <leader><space> <Plug>CommentaryLine

" ------------------------------------------------------------
" CrefVim:
" don't load cref plugin
let loaded_crefvim = 1

" ------------------------------------------------------------
" Dict:
" disable dict
let g:loaded_dict = 1

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
" ipi:
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
vmap <leader>nr :<C-u>silent! IP NarrowRegion<CR>:normal gv<CR><Plug>NrrwrgnDo

" ------------------------------------------------------------
" Netrw:
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

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
" Rename:
if exists(":Rename") != 2
	command -bang -nargs=+ Rename :delc Rename|silent! exec ":IP rename"|Rename<bang> <args>
endif

" ------------------------------------------------------------
" Session:
let g:session_directory = fnameescape(g:vimdir.g:sep.'.tmp'.g:sep.'sessions')

" ------------------------------------------------------------
" Supertab:
let g:SuperTabDefaultCompletionType = "<c-n>"

" ------------------------------------------------------------
" Tabular:
vnoremap <leader>t :<C-u>silent! IP tabular<CR>:normal gv<CR>:Tabularize /
if exists(":Tabularize") != 2
	command -range -nargs=+ Tabularize :delc Tabularize|silent! exec "IP tabular"|Tabularize <args>
endif

" ------------------------------------------------------------
" Tagbar:
" convenience shortcut for opening tagbar
nnoremap <leader>t :silent! IP tagbar<CR>:TagbarToggle<CR>

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
