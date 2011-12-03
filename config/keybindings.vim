" Keymappings:
" ------------

" yank/paste to/from clipboard
nnoremap gpc "+p
vnoremap gyc "+y

" replace within the visual selection
vnoremap gvs :<BS><BS><BS><BS><BS>%s/\%V

" in addition to the gf and gF commands:
" edit file and create it in case it doesn't exist
nnoremap gcf :e <cfile><CR>

" edit files in PATH environment variable
nnoremap gxf :exec ':e '.system('which '.expand("<cfile>"))<CR>

" save current file
inoremap <F2>   <C-o>:w<CR>
inoremap <S-F2> <C-o>:w!<CR>
nnoremap <F2>   :w<CR>
nnoremap <S-F2> :w!<CR>

" insert absolute path of current filename, behavior is similar to normal mode mapping of <C-g>
cnoremap <C-g> <C-r>=expand('%:p')<CR>
" insert trailing part of the path (the current filename without any leading directories)
cnoremap <C-t> <C-r>=expand('%:t')<CR>
" copy current filename to clipboard
nnoremap <silent> <M-c> :let @* = expand("%:p")<CR>:echo "Copied: ".expand("%:p")<CR>

" clear search register, useful if you want to get rid of too much highlighting
nnoremap <silent> <leader>/ :let @/ = ""<CR>:echo "Cleared search register"<CR>

" make moving between the windows easier
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l

" Changes To The Default Behavior:
" --------------------------------

let maplocalleader = ','

" disable <F1> mapping to open vim help - especially on Lenovo laptops <F1> is
" in the way of <Esc> which is really annoying
imap <F1> <Nop>
map <F1> <Nop>

" fast quit without saving anything
nnoremap <silent> ZQ :qa!<CR>

" fast quit with saving everything
nnoremap <silent> ZZ :wa<CR>:qa<CR>

" change default behavior to not start the search immediately
" have a look at :h restore-position
nnoremap <silent> * ms"zyiwHmt/\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>
nnoremap <silent> # ms"zyiwHmt?\<<C-r>z\><CR>'tzt`s:let @"=@0<CR>

" start new undo sequences when using certain commands in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
if has('gui_running')
	inoremap <C-H> <C-G>u<C-H>
endif
inoremap <Del> <C-G>u<Del>

" delete words in insert and command mode like expected - doesn't work properly
" at the end of lines
imap <C-BS> <C-w>
cmap <C-BS> <C-w>
imap <C-Del> <C-o>dw
cmap <C-Del> <C-Right><C-w>
if !has('gui_running')
	cmap <C-H> <C-w>
	imap <C-H> <C-w>
endif

" Search for the occurrence of the word under the cursor
nnoremap <silent> [I [I:let nr = input("Item: ")<Bar>if nr != ''<Bar>exe "normal " . nr ."[\t"<Bar>endif<CR>

" change behavoir of Y to be in accordance with C and D
nmap Y y$

" make ge/moving to the end of the previous word more accessible
nmap - ge

" browse through files
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

" fast access to the shell
nnoremap <leader><leader> :!
