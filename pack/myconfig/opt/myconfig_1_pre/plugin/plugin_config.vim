" Plugin Settings

if (exists("g:loaded_plugin_config") && g:loaded_plugin_config) || &cp
    finish
endif
let g:loaded_plugin_config = 1

" activate filetype auto detection, automatically load filetypeplugins, indent according to the filetype
filetype plugin indent on

" Current Word {{{1
hi CurrentWordTwins gui=underline cterm=underline
hi link CurrentWord CurrentWordTwins

" editqf {{{1
nnoremap <leader>n :<C-u>QFAddNote<CR>

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
