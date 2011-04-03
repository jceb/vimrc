#Readme

##Introduction

VimCalc provides a convenient way to access a powerful interactive calculator
whilst inside a Vim session. Quickly rattle off a few sums to test an idea.
Perform complex calculations using built-in functions to validate answers.
Quickly and simply convert from octal to hex to decimal and back again. Setup
a bunch of variables to be used in a complex expression. Change variables
easily and then simply re-evaluate the expression. Whatever you may need a
calculator for, VimCalc is up to the task.

Not only can VimCalc calculate but it uses Vim for input and editing. Quickly
and easily perform edits on previous calculations using the power of Vim and
then re-evaluate them by simply hitting return. Once you've got the answers yank
them into several registers and paste with ease into other buffers!

Here are some example expressions run in a VimCalc session:
<code>
    > 5+4
    ans = 9.0
    > let x = 4
    x = 4.0
    > 9 * sqrt(4)
    ans = 18.0
    > 9**2 - (sqrt(4)+2)
    ans = 77.0
    > 0xff + 2
    ans = 257.0
</code>

Here is an example of calculating the roots of a quadratic
equation:
<code>
    > let a = 2
    a = 2.0
    > let b = -1
    b = -1.0
    > let c = -6
    c = -6.0
    > ((b*-1) + sqrt(b**2 - 4*a*c))/(2*a)
    ans = 2.0
    > ((b*-1) - sqrt(b**2 - 4*a*c))/(2*a)
    ans = -1.5
</code>

##Installation

###Requirements

  * Vim 7.0+ with +python.
  * Python installed.

If you're compiling Vim from source, be sure to use the --enable-pythoninterp
option. Otherwise check your OS's package distro for a version of Vim with
Python support. On OS X the best option is MacVim. VimCalc should work on
Windows too, you will need to install the correct python dll for the version
of Vim you are using. Please see the web for help with this.

###Installation

Download the latest source from https://github.com/gregsexton/VimCalc.

Extract (or copy) all of the files into your Vim runtime directory, ensuring
that they are placed into the correct subdirectories. Then update your help
tags file to enable VimCalc help. See :help add-local-help in Vim for details.
