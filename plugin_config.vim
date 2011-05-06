" load manpage-plugin
runtime! ftplugin/man.vim

" load matchit-plugin
runtime! macros/matchit.vim


" Plugin Settings:
" ----------------

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

" DumbBuf:
let g:dumbbuf_hotkey = '<leader>b'
let g:dumbbuf_cursor_pos = 'keep'
let g:dumbbuf_mappings = {
  \"n": {
	  \"<Esc>": {"alias_to": "q"}
  \}
\}

" Txtbrowser:
" don't load the plugin cause it's not helpful for my workflow
" id=txtbrowser_disabled
let g:txtbrowser_version = "don't load!"

" EasyMotion:
let g:EasyMotion_target_hl = "Error"

" Fastwordcompleter:
let g:fastwordcompleter_filetypes = '*'
"let g:fastwordcompleter_filetypes = 'asciidoc,mkd,txt,mail,help'

" Netrw:
" hide dotfiles by default - the gh mapping quickly changes this behavior
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" GetLatestVimScripts:
" don't allow autoinstalling of scripts
let g:GetLatestVimScripts_allowautoinstall = 0

" XML Ftplugin:
let xml_use_xhtml = 1

" ToHTML:
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" Python Highlighting:
let python_highlight_all = 1

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

"nnoremap <leader>fh :FufHelp<CR>
nnoremap <leader>fb :FufBuffer<CR>
nnoremap <leader>fr :FufMruFile<CR>
nnoremap <leader>fd :FufDir<CR>
nnoremap <leader>fD :FufDir <C-r>=Expand_file_directory()<CR><CR>
nmap <leader>Fd <leader>fD
nmap <leader>FD <leader>fD
nnoremap <leader>ff :FufFile<CR>
nnoremap <leader>fF :FufFile <C-r>=Expand_file_directory()<CR><CR>
nmap <leader>FF <leader>fF
nnoremap <leader>fR :FufRenewCache<CR>
let g:fuf_modesDisable = [ 'help', 'bookmark', 'tag', 'taggedfile', 'quickfix', 'mrucmd', 'jumplist', 'changelist', 'line' ]
let g:fuf_scratch_location  = 'botright'
let g:fuf_maxMenuWidth = 300
let g:fuf_file_exclude = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)|\.pyo|\.pyc|autom4te\.cache|blib|_build|\.bzr|\.cdv|cover_db|CVS|_darcs|\~\.dep|\~\.dot|\.git|\.hg|\~\.nib|\.pc|\~\.plst|RCS|SCCS|_sgbak|\.svn'
let g:fuf_previewHeight = 0

" YankRing:
nnoremap <silent> <F8> :YRShow<CR>

let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
let g:yankring_ignore_operator = 'g~ gu gU ! = gq g? > < zf g@'
let g:yankring_history_file = '.yankring_history_file'
let g:yankring_map_dot = 0

" Supertab:
let g:SuperTabDefaultCompletionType = "<c-n>"

" TagList:
let Tlist_Sort_Type = "order"
let Tlist_Show_One_File = 1

" NERD Commenter:
" toggle comment
nmap <leader><space> <plug>NERDCommenterToggle
vmap <leader><space> <plug>NERDCommenterToggle
" insert current comment leader in insert mode
imap <C-c> <C-o>:call NERDComment(0, "insert")<CR>

" NERDTree:
nmap <leader>e :NERDTreeToggle<CR>
" integrate with cdargs
let g:NERDTreeBookmarksFile = $HOME.'/.cdargs'
let g:NERDTreeIgnore = ['\.pyc$', '\~$']

" Universal Text Linking:
if $DISPLAY != "" || has('gui_running')
	let g:utl_cfg_hdl_scm_http = "silent !x-www-browser '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !x-terminal-emulator -e mutt '%u'"
	for pdfviewer in ['xpdf', 'evince', 'okular', 'kpdf', 'acroread']
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
nnoremap gl :Utl<CR>
vnoremap gl :Utl o v<CR>
" copy/yank link
nnoremap gyl :Utl cl<CR>
vnoremap gyl :Utl cl v<CR>

" Txtfmt:
" disable map warnings and overwrite any conflicts
let g:txtfmtMapwarn = "cC"

" LanguageTool:
let g:languagetool_jar=$HOME . '/.vim/bundle/LanguageTool/LanguageTool.jar'

" Toggle:
" add another toggle mapping which is more convenient
nmap - :call Toggle()<CR>
vmap - <Esc>:call Toggle()<CR>

" Gundo:
nmap <leader>u :GundoToggle<CR>

" Orgmode:
let g:org_taglist_level = 2
let g:org_tags_completion_ignorecase = 1

" UltiSnips:
let g:UltiSnipsRemoveSelectModeMappings = 0
