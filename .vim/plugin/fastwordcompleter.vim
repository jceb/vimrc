" fastwordcompleter.vim:	automatically offers word completion
" Last Modified: Sat 25. Apr 2009 23:13:19 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1
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
"  To activate, choose "Word Completion" from the Tools menu, or type 
"  :call DoFastWordComplete() 
"  To make it stop, choose "Tools/Stop Completion", or type 
"  :call EndFastWordComplete()
"  If you want to activate the script for certain filetypes, add the line
"  	let g:fastwordcomplete_filetypes = 'filetype,...'
"  to your vimrc file.

if has("menu")
  amenu &Tools.&Word\ Completion :call DoFastWordComplete()<CR>
  amenu &Tools.&Stop\ Completion :call EndFastWordComplete()<CR>
endif

" Make an :imap for each alphabetic character, and define a few :smap's.
fun! DoFastWordComplete()
  if has("mac")
    snoremap <buffer>  <Del>a
  else
    snoremap <buffer> <BS> <Del>a
  endif "has("mac")
  if version > 505
    snoremap <buffer> <C-N> <Del>a<C-N>
    snoremap <buffer> <C-P> <Del>a<C-P><C-P>
    snoremap <buffer> <C-X> <Del>a<C-P><C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = "a"
  while letter <=# "z"
    execute "inoremap <buffer>" letter letter . "<C-n><C-p>"
    let letter = nr2char(char2nr(letter) + 1)
  endwhile
endfun

" Remove all the mappings created by DoFastWordComplete().
" Lazy:  I do not save and restore existing mappings.
fun! EndFastWordComplete()
  if has("mac")
    vunmap <buffer> 
  else
    vunmap <buffer> <BS>
  endif "has("mac")
  if version > 505
    vunmap <buffer> <C-N>
    vunmap <buffer> <C-P>
    vunmap <buffer> <C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = char2nr("a")
  while letter <= char2nr("z")
    execute "iunmap <buffer>" nr2char(letter)
    let letter = letter + 1
  endwhile
endfun

if (exists('g:fastwordcomplete_filetypes') && len(g:fastwordcomplete_filetypes) > 0)
    exec 'au FileType '.g:fastwordcomplete_filetypes.' :call DoFastWordComplete()'
endif
" vim:sts=2:sw=2:ff=unix:
