Chapa
=====
Allows you to move to previous/next N class, function or method 

or visually select the next/previous N class, function or method 

or comment (or toggle) out the next/previous N class, function or method.

As this is a "file-type plugin", it currently supports both Python and Ruby.

Watch the screencast: http://vimeo.com/19016562

Installation couldn't be easier: drop the ftplugin file in your vim ftplugin 
directory. For example, if you are using Python, this would be something like::

    ~/.vim/ftplugin/python/chapa.vim

I would highly recommend you use something like Pathogen though, it 
makes dealing with VIM plugins way easier.

1. Intro                                 
==============================================================================

After trying other plugins that were supposed to achieve this objective (and 
fail) I decided to write it on my own.  

No need to have VIM compiled with Python or Ruby support since this plugin uses 
pure VIM syntax.

2. Usage                                
==============================================================================

There are a couple of routes you can take: with or without default mappings.

If you want to define your own mappings then no need to do anything else other 
than know the actual plugin calls (listed below).

If you want the default mappings (also listed below) you need to add this to 
your vimrc::

    let g:chapa_default_mappings = 1

You can also make the repeat actions for the plugin optional. If the above 
variable is set but you don't like the repeat mappings, set the following 
in your vimrc::

    let g:chapa_no_repeat_mappings = 1

You can map those callables to anything you want, but below is how the 
defaults are mapped::

    " Repeat Mappings
    nmap <C-h> <Plug>ChapaOppositeRepeat
    nmap <C-l> <Plug>ChapaRepeat

    " Function Movement
    nmap fnf <Plug>ChapaNextFunction
    nmap fpf <Plug>ChapaPreviousFunction

    " Class Movement
    nmap fnc <Plug>ChapaNextClass
    nmap fpc <Plug>ChapaPreviousClass

    " Method Movement
    nmap fnm <Plug>ChapaNextMethod
    nmap fpm <Plug>ChapaPreviousMethod

    " Class Visual Select 
    nmap vnc <Plug>ChapaVisualNextClass
    nmap vic <Plug>ChapaVisualThisClass 
    nmap vpc <Plug>ChapaVisualPreviousClass

    " Method Visual Select
    nmap vnm <Plug>ChapaVisualNextMethod
    nmap vim <Plug>ChapaVisualThisMethod
    nmap vpm <Plug>ChapaVisualPreviousMethod

    " Function Visual Select
    nmap vnf <Plug>ChapaVisualNextFunction
    nmap vif <Plug>ChapaVisualThisFunction
    nmap vpf <Plug>ChapaVisualPreviousFunction

    " Comment Class
    nmap cic <Plug>ChapaCommentThisClass
    nmap cnc <Plug>ChapaCommentNextClass
    nmap cpc <Plug>ChapaCommentPreviousClass

    " Comment Method 
    nmap cim <Plug>ChapaCommentThisMethod 
    nmap cnm <Plug>ChapaCommentNextMethod 
    nmap cpm <Plug>ChapaCommentPreviousMethod 

    " Comment Function 
    nmap cif <Plug>ChapaCommentThisFunction
    nmap cnf <Plug>ChapaCommentNextFunction
    nmap cpf <Plug>ChapaCommentPreviousFunction

    " Folding Method
    nmap zim <Plug>ChapaFoldThisMethod
    nmap znm <Plug>ChapaFoldNextMethod
    nmap zpm <Plug>ChapaFoldPreviousMethod

    " Folding Class
    nmap zic <Plug>ChapaFoldThisClass
    nmap znc <Plug>ChapaFoldNextClass
    nmap zpc <Plug>ChapaFoldPreviousClass

    " Folding Function
    nmap zif <Plug>ChapaFoldThisFunction
    nmap znf <Plug>ChapaFoldNextFunction
    nmap zpf <Plug>ChapaFoldPreviousFunction


If the requested search (function, class or method) is not found, the call simply 
returns and nothing should happen. However, there is an error message that should 
display by default, explaining what it was supposed to search and in what 
direction.

You can disable this by adding a chapa-specific variable in your vimrc::

  let g:chapa_messages = 0

You can also add a "count" to repeat the match N times. So if you want to go 
to the 3rd previous class you would (with the mappings above) do something like::

  3fpc

The same applies for visual selections. If you want to visually select the 3rd
next method, you would do it like::

  3vnm

You can also toggle comments of a given class, method or function. To comment
the next class::

  cnc 

If the class is already commented, the command above will remove the comments.

If you are moving around, the plugin allows you to repeat the forward or
reverse (opposite to the original) move. For example, if you searched for the 
next function like::

   fpf 

Then ``<C-l>`` repeats that same command for you and moves you in the same 
direction. If you want to go in the opposite movement, then ``<C-h>`` is your
friend.


3. License                             
==============================================================================

MIT
Copyright (c) 2010-2011 Alfredo Deza <alfredodeza [at] gmail [dot] com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

4. Bugs                               
==============================================================================

If you find a bug please post it on the issue tracker:
https://github.com/alfredodeza/chapa.vim/issues

5. Credits                           
==============================================================================

A lot of the code for this plugin was adapted/copied from python.vim 
and python_fn.vim authored by Jon Franklin and Mikael Berthe. 

