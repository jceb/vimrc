" fastwordcompleter.vim:	automatically offers word completion
" Last Modified: Fri 05. Mar 2010 17:37:56 +0100 CET
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.2
"
" inspired by http://vim.sourceforge.net/scripts/script.php?script_id=73

" DESCRIPTION:
"  Each time you type an alphabetic character, the script attempts to complete
"  the current word. The suggested completion is draw below the word you are
"  typing. Type <C-N> to select the completion and continue with the next word.

" LIMITATIONS:
"  The script works by :imap'ping each alphabetic character, and uses
"  Insert-mode completion (:help ins-completion). It is far from perfect.
"  If there is in total only one option to complete, no completion will be
"  display because of vim's completion menu implementation.

" INSTALLATION:
"  :source it from your vimrc file or drop it in your plugin directory.
"  To activate, choose "Start Autocompletion" from the Tools menu, or type
"  :call FastWordCompletionStart()
"  To make it stop, choose "Plugin/Stop Autocompletion", or type
"  :call FastWordCompletionStop()
"  If you want to activate the script for certain filetypes, add the line
"  	let g:fastwordcomplete_filetypes = 'filetype,...'
"  to your vimrc file.

if (exists("g:loaded_fastwordcompletion") && g:loaded_fastwordcompletion) || &cp
    finish
endif
let g:loaded_fastwordcompletion = 1

if !exists('g:fastwordcompletion_nomenuone')
  set completeopt=menuone
endif

" Make an :imap for each alphabetic character, and define a few :smap's.
fun! s:FastWordCompletionStart()
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = char2nr("A")
  let letter_to = char2nr("z")
  while letter <= letter_to
  	let char = nr2char(letter)
    execute "inoremap <buffer> ".char.' '.char."<C-n><C-p>"
    let letter += 1
  endwhile
endfun

" Remove all the mappings created by FastWordCompletionStart().
" Lazy:  I do not save and restore existing mappings.
fun! s:FastWordCompletionStop()
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = char2nr("a")
  let letter_to = char2nr("Z")
  while letter <= letter_to
    execute "iunmap <buffer> ".nr2char(letter)
    let letter = letter + 1
  endwhile
endfun

if (exists('g:fastwordcomplete_filetypes') && len(g:fastwordcomplete_filetypes) > 0)
    exec 'au FileType '.g:fastwordcomplete_filetypes.' :FastWordCompletionStart'
endif

if has("menu")
  amenu &Plugin.&FastWordCompleter.&Start\ Autocompletion :FastWordCompletionStart<CR>
  amenu &Plugin.&FastWordCompleter.Sto&p\ Autocompletion :FastWordCompletionStop<CR>
endif

command! -nargs=0 FastWordCompletionStart call <SID>FastWordCompletionStart()
command! -nargs=0 FastWordCompletionStop call <SID>FastWordCompletionStop()

" vim:sts=2:sw=2:ff=unix:
