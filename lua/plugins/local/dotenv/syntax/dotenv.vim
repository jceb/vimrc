" Vim syntax file
" Filetype:	dotenv
" Author:	Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:	1.0

syntax clear
syntax case match

syntax match dotenvComment	/^#.*/
syntax match dotenvValue	contained	/=\zs.*/
" syntax match dotenvEntry	/^[A-Za-z0-9_-]\+=.*/
syntax match dotenvEntry	contains=dotenvValue keepend	/^[A-Za-z0-9_-]\+=.*/ 

highlight link dotenvComment	Comment
highlight link dotenvValue	String
highlight link dotenvEntry	Label

let b:current_syntax = "dotenv"
