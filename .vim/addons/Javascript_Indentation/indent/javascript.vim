"
" Copyright 2006 Tye Zdrojewski 
"
" Licensed under the Apache License, Version 2.0 (the "License"); you may not
" use this file except in compliance with the License. You may obtain a copy of
" the License at
" 
" 	http://www.apache.org/licenses/LICENSE-2.0
" 
" Unless required by applicable law or agreed to in writing, software distributed
" under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
" CONDITIONS OF ANY KIND, either express or implied. See the License for the
" specific language governing permissions and limitations under the License.
" 
"
"
" Script:
"
"   Javascript Indentation
"
" Version: 1.1.2
"
" Description:
"
"   Indentation for Javascript.  This script uses the IndentAnything plugin.
"
"
" Installation:
"
"   Place this file in your home directory under ~/.vim/indent/, or replace
"   the system indent/javascript.vim file to affect all users.
"
" Maintainer: Tye Z. <zdro@yahoo.com>
"
"
" History:
"
"   1.1.1  -  Added license
"   1.1.2  -  Added indentation for [...] pairs
"   1.1.3  -  Fixed silly syntax error
"
"

let IndentAnything_Dbg = 0
let IndentAnything_Dbg = 1

" Only load this indent file when no other was loaded.
if exists("b:did_indent") && ! IndentAnything_Dbg
  finish
endif

let b:did_indent = 1

setlocal indentexpr=IndentAnything()
setlocal indentkeys+=0),0},),;

" Only define the function once.
if exists("*IndentAnything") && ! IndentAnything_Dbg
  finish
endif

setlocal indentexpr=IndentAnything()

""" BEGIN IndentAnything specification

"
" Syntax name REs for comments and strings.
"
let b:commentRE      = 'javaScript\(Line\)\?Comment'
let b:lineCommentRE  = 'javaScriptLineComment'
let b:blockCommentRE = 'javaScriptComment'
let b:stringRE            = 'javaScriptString\(S\|D\)'
let b:singleQuoteStringRE = 'javaScriptStringS'
let b:doubleQuoteStringRE = 'javaScriptStringD'


"
" Setup for C-style comment indentation.
"
let b:blockCommentStartRE  = '/\*'
let b:blockCommentMiddleRE = '\*'
let b:blockCommentEndRE    = '\*/'
let b:blockCommentMiddleExtra = 1

"
" Indent another level for each non-closed paren/'(' , bracket/'[', and
" brace/'{' on the previous line.

let b:indentTrios = [
            \ [ '(',  '',                      ')'  ],
            \ [ '{',  '\(default:\|case.*:\)', '}'  ],
            \ [ '\[', '',                      '\]' ]
\]


"
" Line continuations.  Lines that are continued on the next line are
" if/for/while statements that are NOT followed by a '{' block and operators
" at the end of a line.
"
let b:lineContList = [
            \ { 'pattern' : '^\s*\(if\|for\|while\)\s*(.*)\s*\(\(//.*\)\|/\*.*\*/\s*\)\?\_$\(\_s*{\)\@!' },
            \ { 'pattern' : '^\s*else' .                 '\s*\(\(//.*\)\|/\*.*\*/\s*\)\?\_$\(\_s*{\)\@!' },
            \ { 'pattern' : '\(+\|=\|+=\|-=\)\s*\(\(//.*\)\|/\*.*\*/\s*\)\?$' }
\]

"
" If a continued line and its continuation can have line-comments between
" them, then this should be true.  For example,
"
"       if (x)
"           // comment here
"           statement
"
let b:contTraversesLineComments = 1

