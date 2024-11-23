" asciidoc.vim -- Asciidoc compiler
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-03-05
" @Last Modified: Wed 23. Apr 2008 10:42:57 +0200 CEST
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  : sets makeprg for asciidoc
" @Usage        :
" @TODO         :
" @CHANGES      :

if exists("b:current_compiler")
  finish
endif
let b:current_compiler = "asciidoc"

setlocal makeprg=asciidoc\ $*\ \"%:p\"
setlocal errorformat=FAILED:\ %f:\ line\ %l:\ %m,ERROR:\ %f:\ line\ %l:\ %m
