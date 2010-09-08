" Vim plugin -- narrrow region
" Version      : 1.0
" Last change  : 2007-10-06
" Maintainer   : A.Politz <cbyvgmn@su-gevre.qr> ( g?? )

func! narrow_region#Narrow() range
  if !exists('b:narrow_region')
    let b:narrow_region = { 'opts' : {}  }
    let b:narrow_region.opts.fdm = &l:fdm
    let b:narrow_region.opts.fen = &l:fen
    let b:narrow_region.opts.fml = &l:fml
    let b:narrow_region.opts.fcl = &fcl
    let b:narrow_region.opts.fdo = &fdo
    let b:narrow_region.foldstates = filter(map(range(1,line('$')),'foldclosed(v:val)'),'v:val > 0')
    setl fdm=manual
    setl fen
    setl fml=0
    setl fcl=all
    setl fdo=undo
  else
    call s:UnsetPlugOpts()
  endif

  let b:narrow_region.firstline = a:firstline
  let b:narrow_region.lastline = a:lastline

  normal! zE
  if a:firstline > 1 
    exec "1,".(a:firstline-1)."fold"
  endif
  if a:lastline < line('$')
    exec (a:lastline+1).",$fold"
  endif
  call s:SetPlugOpts()
endfun

func! narrow_region#UnNarrow()
  if !exists('b:narrow_region')
    return 0
  endif
  for [ o, v] in items(b:narrow_region.opts)
    exec "let &l:".o."='".v."'"
  endfor
  normal! zR
  let lnum = 0
  for l in b:narrow_region.foldstates
    if l > lnum
      silent! exec l."foldclose"
      let lnum = l 
    endif
  endfor
  call s:UnsetPlugOpts()

  unlet b:narrow_region
  return 1
endfun

func! s:SetPlugOpts( )
  if exists('g:narrow_region_options')
    let opts = g:narrow_region_options
  else
    let opts = ':'
  endif
  let range = (b:narrow_region.firstline).','.(b:narrow_region.lastline)
  for o in split(opts,'\ze')
    if o == ':'
      exec 'cnoremap <expr><buffer> : getcmdpos() == 1 ? "'.range.'":":"' 
    elseif o == 'c'
      exec 'cabbr <buffer> g '.range.'g'
      exec 'cabbr <buffer> s '.range.'s'
      exec 'cabbr <buffer> v '.range.'v'
    elseif o == 'h'
      hi! link Folded Ignore
    else
      echohl Error
      echo "Warning : Unknown option '".o."', removing it."
      if exists('g:narrow_region_options')
	let g:narrow_region_options = substitute(g:narrow_region_options,o,'','g')
      endif
      let opts = substitute(opts,o,'','g')
    endif
  endfor
  let b:narrow_region.plugopts = opts
endfun

func! s:UnsetPlugOpts()
  for o in split(b:narrow_region.plugopts,'\ze')
    if o == ':'
      cunmap <buffer> :
    elseif o == 'c'
      cunabbrev <buffer> g
      cunabbrev <buffer> v
      cunabbrev <buffer> s
    elseif o == 'h'
      hi! link Folded Folded
    endif
  endfor
endfun

func! BufIsNarrowed( ... )
  let bnr = a:0 ? a:1 : bufnr('%')
  return !empty(getbufvar(bnr,'narrow_region'))
endfun
