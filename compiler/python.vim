" python.vim -- Python compiler
" @Author       : Jan Christoph Ebersbach (jceb@e-jc.de)
" @License      : GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created      : 2010-12-26
" @Last Modified: Sun 26. Dec 2010 12:06:41 +0100 CET
" @Revision     : 0.0
" @vi           : ft=vim:tw=80:sw=4:ts=4
" 
" @Description  : sets makeprg for python
" @Dependencies : Pylint (http://www.logilab.org/project/pylint)
" @Usage        : Just type :make to check the current python file with pylint
" @TODO         :
" @CHANGES      :

if exists("b:current_compiler")
  finish
endif
let b:current_compiler = "python"

set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m
