" Plugin Settings

if (exists("g:loaded_plugin_config") && g:loaded_plugin_config) || &cp
    finish
endif
let g:loaded_plugin_config = 1

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" General vim plugins {{{1
let g:no_mail_maps = 1

" CrefVim {{{1
" don't load cref plugin
let loaded_crefvim = 1

" Current Word {{{1
hi CurrentWordTwins gui=underline cterm=underline
hi link CurrentWord CurrentWordTwins

" dirvish {{{1
let g:loaded_netrwPlugin = 1 " disable netrw .. but I want to have the gx command!!

" Speed booster
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_2html_plugin = 1
" let g:loaded_matchparen = 1

" editqf {{{1
nnoremap <leader>n :<C-u>nunmap <leader>n<Bar>packadd editqf<Bar>QFAddNote<CR>

" ftplugin: svelte {{{1

function! OnChangeSvelteSubtype(subtype)
  echo 'Subtype is '.a:subtype
  if empty(a:subtype) || a:subtype == 'html'
    setlocal commentstring=<!--%s-->
    setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
  elseif a:subtype =~ 'css'
    setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
  else
    setlocal commentstring=//%s
    setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
  endif
endfunction

" LanguageTool {{{1
let g:languagetool_jar=$HOME . '/.config/nvim/pack/vimscripts/opt/LanguageTool/LanguageTool/languagetool-commandline.jar'
if exists(':LanguageToolCheck') != 2
    command! -nargs=0 LanguageToolCheck :delc LanguageToolCheck|packadd LanguageTool|LanguageToolCheck
endif

" Man {{{1
" load manpage-plugin
"runtime! ftplugin/man.vim
" cut startup time dramatically by loading the man plugin on demand
if exists(':Man') != 2
	command! -nargs=+ Man :delc Man|runtime! ftplugin/man.vim|Man <args>
endif

" Python Highlighting {{{1
let python_highlight_all = 1

" python-mode {{{1
let g:pymode_python = 'python3'
let g:pymode_lint = 0 " disable linter because ale takes care of that
let g:pymode_rope = 0
let g:pymode_lint_ignore = "E501,W191"
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']

" ToHTML {{{1
let html_number_lines = 1
let html_use_css = 1
let use_xhtml = 1

" XML Ftplugin {{{1
let xml_use_xhtml = 1

" vi {{{1
" vi: ft=vim:tw=80:sw=4:ts=4:sts=4:et:fdm=marker
