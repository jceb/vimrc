" Autocommands:
" -------------

if ! has('autocmd')
	finish
endif

augroup ft_text
  au!
  " au FileType *							setlocal iskeyword+=_
  au FileType mail,help,debchangelog,tex,plaintex,txt,asciidoc,markdown,org
        \ setlocal formatoptions=t iskeyword+=- textwidth=120 complete+=kspell sw=2 ts=2 sts=2
  au FileType markdown					setlocal formatoptions-=t
  au FileType debchangelog,gitcommit,hg	setlocal spell spelllang=en
  au FileType help						setlocal nolist textwidth=0
  au FileType help						nnoremap <buffer> q :q<cr> " close help buffer by just pressing q
  au FileType man						setlocal nolist
  au FileType org						setlocal foldminlines=0 foldlevel=1
  au FileType tex,plaintex				setlocal makeprg=pdflatex\ \'%:p\'
  au FileType asciidoc					setlocal formatlistpat=^\\s*\\([:alnum:]\\+\\.\\\|-\\\|[.*]\\+\\)\\s\\+ formatoptions+=nc
  au FileType org						setlocal textwidth=77
  au FileType mail						setlocal textwidth=0 wrap cpoptions-=J commentstring=>%s comments+=b:-- spell spelllang=de formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\|[-*#]\\)\\s* | call formatmail#FormatMail()
  au BufReadPost,BufNewFile app.textusm.com*	setlocal sw=2 sts=2 ts=2
augroup END

augroup ft_programming
  au!
  " au FileType java,c,cpp,python,automake,make	setlocal noexpandtab nosmarttab
  " au FileType javascript				UltiSnipsAddFiletypes javascript-jsdoc
  " au FileType python						setlocal sts=4 ts=4 sw=4 " See PEP 8
  " au FileType ruby						setlocal sts=2 ts=2 sw=2
  " au FileType serif						setlocal filetype=serif.javascript | setlocal commentstring=#%s comments=
  au FileType *							setlocal foldcolumn=1
  au FileType c							setlocal commentstring=/*%s*/
  au FileType cpp						setlocal commentstring=//%s
  au FileType dosbatch					setlocal commentstring=::\ %s
  au FileType gomod						setlocal commentstring=//%s comments=s1:/*,mb:*,ex:*/,://
  au FileType helm						setlocal ts=2 sw=2 sts=2
  au FileType python					setlocal omnifunc=python3complete#Complete textwidth=79 expandtab sts=2 ts=2 sw=2
  au FileType solidity					setlocal comments=://
  au FileType typescript,javascript,serif,vue,svelte,nu,yaml,helm,nix,vim				setlocal shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup ft_general
  au!
  " Source: https://stackoverflow.com/questions/3374938/set-vim-to-open-files-in-read-only-mode-by-default
  " autocmd SwapExists * let v:swapchoice = "o"

  au BufEnter *.tid,127.0.0.1__*TEXTAREA*.txt	setf tiddlywiki
  au BufEnter github.com*.txt					setf markdown
  au BufReadPost,BufNewFile Dockerfile-*		setf dockerfile
  au BufReadPost,BufNewFile docker-compose*.yaml	setf docker-compose
  au BufReadPost,BufNewFile *.jsonld,tiddlywiki.info	setf json
  au BufReadPost,BufNewFile *.nix				setf nix
  au BufReadPost,BufNewFile *.hbs				setf html
  au BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,*.gotmpl,helmfile*.yaml set ft=helm.yaml
  au BufReadPost,BufNewFile *.mjs,*.cjs			setf javascript
  au BufReadPost,BufNewFile *.adoc				setf asciidoc
  au BufReadPost,BufNewFile *.svelte			setf svelte
  au BufReadPost,BufNewFile *.go				setf go
  au BufReadPost,BufNewFile *.fish				setf fish
  au BufReadPost,BufNewFile *.jsx				setf javascript.jsx
  au BufReadPost,BufNewFile *.tsx				setf typescript.tsx
  au BufReadPost,BufNewFile *.vue				setf vue
  au BufReadPost,BufNewFile *.sol				setf solidity
  au BufReadPost,BufNewFile *.hcl,*.terraform	setf terraform
  au BufReadPost,BufNewFile *.puml,*.plantuml	setf plantuml
  au BufReadPost,BufNewFile *.http				setf http
  au BufReadPost,BufNewFile *.jwk				setf json
  au BufReadPost,BufNewFile *.nu				setf nu
  au BufReadPost,BufNewFile *.service,*.timer	setf toml
  au BufReadPost,BufNewFile *					setlocal cpoptions-=J formatoptions+=rcjnq formatoptions-=o " o is really annoying
  au FocusGained *								checktime " run checks like autoread as soon as vim regains focus
  " au TermOpen *								setlocal nonumber norelativenumber | startinsert " start insert mode when a new terminal is opened
  au InsertLeave *								set nopaste " disable paste when leaving insert mode
  " if exists('##TextYankPost')
  "     autocmd TextYankPost * silent lua return (not vim.v.event.visual) and require'vim.highlight'.on_yank({ higroup = 'MatchParen'; timeout = 200 })
  " endif
augroup END
