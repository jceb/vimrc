" Vim plugin -- narrrow region
" Version      : 1.0
" Last change  : 2007-10-06
" Maintainer   : A.Politz <cbyvgmn@su-gevre.qr> ( g?? )

if exists('g:loaded_narrow_region')
  finish
endif

let g:loaded_narrow_region = 1

if version < 700
  echohl Error | echo "NarrowRegion: Vim 7.x required, your version is ".(version/100).".".(version%100) | echohl None
  finish
endif

com -range NarrowRegion <line1>,<line2>call narrow_region#Narrow()
com UnNarrowRegion call narrow_region#UnNarrow()
