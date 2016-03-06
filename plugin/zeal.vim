" derived from zeavim: https://github.com/KabbAmine/zeavim.vim
" Author: Jan Christoph Ebersbach <jceb@e-jc.de>
" Version: 0.1

let s:zeavimDocsetNames = {
			\ 'c': 'C',
			\ 'cpp': 'C++',
			\ 'css': 'Css',
			\ 'html': 'Html',
			\ 'java': 'Java',
			\ 'js': 'Javascript',
			\ 'markdown': 'Markdown',
			\ 'md': 'Markdown',
			\ 'mdown': 'Markdown',
			\ 'mkd': 'Markdown',
			\ 'mkdn': 'Markdown',
			\ 'php': 'Php',
			\ 'py': 'Python',
			\ 'scss': 'sass',
			\ 'sh': 'Bash',
			\ 'tex': 'Latex',
			\ }

function! s:GetZeavimDocset()
	let l:ft = split(&ft, '\.')
	if len(l:ft) > 0
		let l:docset = get(s:zeavimDocsetNames, l:ft[0], '')
		if l:docset
			return l:docset.":"
		endif
		return l:ft[0].":"
	endif
	return ""
endfunction

function! s:GetVisualSelection()
	let s:selection=getline("'<")
	let [line1,col1] = getpos("'<")[1:2]
	let [line2,col2] = getpos("'>")[1:2]
	return s:selection[col1 - 1: col2 - 1]
endfunction

function! s:ExecZeal(query)
	if a:query != ''
		exec ':silent !zeal --query "'.a:query.'" &'
	endif
endfunction

nnoremap <Plug>ZVCall               :silent call <SID>ExecZeal(<SID>GetZeavimDocset().'<cword>')<CR>
nnoremap <Plug>ZVKeyCall            :silent call <SID>ExecZeal('<cword>')<CR>
nnoremap <Plug>ZVKeyDoc             :call <SID>ExecZeal(input('Zeal search: '))<CR>
xnoremap <Plug>ZVVisualSelecCall    :<C-u>call <SID>ExecZeal(<SID>GetVisualSelection())<CR>
xnoremap <Plug>ZVVisualSelecKeyCall :<C-u>call <SID>ExecZeal(<SID>GetZeavimDocset().<SID>GetVisualSelection())<CR>

if ! hasmapto("<Plug>ZVCall", "n")
	nmap <leader>Z <Plug>ZVCall
endif

if ! hasmapto("<Plug>ZVKeyCall", "n")
	nmap <leader>z <Plug>ZVKeyCall
endif

" if ! hasmapto("<Plug>ZVKeyDoc", "n")
" 	nmap <leader><leader>z <Plug>ZVKeyDoc
" endif

if ! hasmapto("<Plug>ZVVisualSelecCall", "v")
	xmap <leader>Z <Plug>ZVVisualSelecCall
endif

if ! hasmapto("<Plug>ZVVisualSelecKeyCall", "v")
	xmap <leader>z <Plug>ZVVisualSelecKeyCall
endif
