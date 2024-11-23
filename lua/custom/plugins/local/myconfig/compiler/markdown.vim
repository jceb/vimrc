" mkd.vim -- MultiMarkdown compiler
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2007-02-05
" @Last Modified: Thu 15. Mar 2007 21:57:28 +0100 CET
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  : sets makeprg for Markdown
" @Usage        :
" @TODO         :
" @CHANGES      :

if exists("b:current_compiler")
  finish
endif
let b:current_compiler = "mkd"

setlocal makeprg=Markdown\ \"$*\"\ \"%:p\"
