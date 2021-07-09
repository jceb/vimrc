" Vim support file to detect file types
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2021 Apr 17

" Listen very carefully, I will say this only once
if exists("did_load_filetypes")
  finish
endif
let did_load_filetypes = 1

" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect

" Ignored extensions
if exists("*fnameescape")
au BufNewFile,BufRead ?\+.orig,?\+.bak,?\+.old,?\+.new,?\+.dpkg-dist,?\+.dpkg-old,?\+.dpkg-new,?\+.dpkg-bak,?\+.rpmsave,?\+.rpmnew,?\+.pacsave,?\+.pacnew
	\ exe "doau filetypedetect BufRead " . fnameescape(expand("<afile>:r"))
au BufNewFile,BufRead *~
	\ let s:name = expand("<afile>") |
	\ let s:short = substitute(s:name, '\~$', '', '') |
	\ if s:name != s:short && s:short != "" |
	\   exe "doau filetypedetect BufRead " . fnameescape(s:short) |
	\ endif |
	\ unlet! s:name s:short
au BufNewFile,BufRead ?\+.in
	\ if expand("<afile>:t") != "configure.in" |
	\   exe "doau filetypedetect BufRead " . fnameescape(expand("<afile>:r")) |
	\ endif
elseif &verbose > 0
  echomsg "Warning: some filetypes will not be recognized because this version of Vim does not have fnameescape()"
endif

" Pattern used to match file names which should not be inspected.
" Currently finds compressed files.
if !exists("g:ft_ignore_pat")
  let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\)$'
endif

" Function used for patterns that end in a star: don't set the filetype if the
" file name matches ft_ignore_pat.
" When using this, the entry should probably be further down below with the
" other StarSetf() calls.
func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc

" Vim help file
au BufNewFile,BufRead $VIMRUNTIME/doc/*.txt setf help
" Ant
au BufNewFile,BufRead build.xml			setf ant

" Apache style config file
au BufNewFile,BufRead proftpd.conf*		call s:StarSetf('apachestyle')

" Apache config file
au BufNewFile,BufRead .htaccess,*/etc/httpd/*.conf		setf apache
au BufNewFile,BufRead */etc/apache2/sites-*/*.com		setf apache

" APT config file
au BufNewFile,BufRead apt.conf		       setf aptconf
au BufNewFile,BufRead */.aptitude/config       setf aptconf
au BufNewFile,BufRead */etc/apt/apt.conf.d/{[-_[:alnum:]]\+,[-_.[:alnum:]]\+.conf} setf aptconf

" Arch Inventory file
au BufNewFile,BufRead .arch-inventory,=tagging-method	setf arch

" AsciiDoc
au BufNewFile,BufRead *.asciidoc,*.adoc		setf asciidoc

" Grub (must be before catch *.lst)
au BufNewFile,BufRead */boot/grub/menu.lst,*/boot/grub/grub.conf,*/etc/grub.conf setf grub

" Atom is based on XML
au BufNewFile,BufRead *.atom			setf xml

" Automake
au BufNewFile,BufRead [mM]akefile.am,GNUmakefile.am	setf automake

" Autotest .at files are actually m4
au BufNewFile,BufRead *.at			setf m4

" Awk
au BufNewFile,BufRead *.awk,*.gawk		setf awk

" BASIC or Visual Basic
au BufNewFile,BufRead *.bas			call dist#ft#FTVB("basic")

" Visual Basic Script (close to Visual Basic) or Visual Basic .NET
au BufNewFile,BufRead *.vb,*.vbs,*.dsm,*.ctl	setf vb

" Batch file for MSDOS.
au BufNewFile,BufRead *.bat,*.sys		setf dosbatch
" *.cmd is close to a Batch file, but on OS/2 Rexx files also use *.cmd.
au BufNewFile,BufRead *.cmd
	\ if getline(1) =~ '^/\*' | setf rexx | else | setf dosbatch | endif

" Batch file for 4DOS
au BufNewFile,BufRead *.btm			call dist#ft#FTbtm()

" BibTeX bibliography database file
au BufNewFile,BufRead *.bib			setf bib

" BIND configuration
" sudoedit uses namedXXXX.conf
au BufNewFile,BufRead named*.conf,rndc*.conf,rndc*.key	setf named

" BIND zone
au BufNewFile,BufRead named.root		setf bindzone
au BufNewFile,BufRead *.db			call dist#ft#BindzoneCheck('')

" C or lpc
au BufNewFile,BufRead *.c			call dist#ft#FTlpc()
au BufNewFile,BufRead *.lpc,*.ulpc		setf lpc

" Calendar
au BufNewFile,BufRead calendar			setf calendar

" C#
au BufNewFile,BufRead *.cs			setf cs

" Cabal
au BufNewFile,BufRead *.cabal			setf cabal

" C++
au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl setf cpp
if has("fname_case")
  au BufNewFile,BufRead *.C,*.H setf cpp
endif

" .h files can be C, Ch C++, ObjC or ObjC++.
" Set c_syntax_for_h if you want C, ch_syntax_for_h if you want Ch. ObjC is
" detected automatically.
au BufNewFile,BufRead *.h			call dist#ft#FTheader()

" Cascading Style Sheets
au BufNewFile,BufRead *.css			setf css

" Changelog
au BufNewFile,BufRead changelog.Debian,changelog.dch,NEWS.Debian,NEWS.dch,*/debian/changelog
					\	setf debchangelog

au BufNewFile,BufRead [cC]hange[lL]og
	\  if getline(1) =~ '; urgency='
	\|   setf debchangelog
	\| else
	\|   setf changelog
	\| endif

au BufNewFile,BufRead NEWS
	\  if getline(1) =~ '; urgency='
	\|   setf debchangelog
	\| endif

" Clojure
au BufNewFile,BufRead *.clj,*.cljs,*.cljx,*.cljc		setf clojure

" Cmake
au BufNewFile,BufRead CMakeLists.txt,*.cmake,*.cmake.in		setf cmake

" Configure scripts
au BufNewFile,BufRead configure.in,configure.ac setf config

" Dockerfilb; Podman uses the same syntax with name Containerfile
au BufNewFile,BufRead Containerfile,Dockerfile,*.Dockerfile	setf dockerfile

" Elixir or Euphoria
au BufNewFile,BufRead *.ex call dist#ft#ExCheck()

" Elixir
au BufRead,BufNewFile mix.lock,*.exs setf elixir
au BufRead,BufNewFile *.eex,*.leex setf eelixir

" Euphoria 3 or 4
au BufNewFile,BufRead *.eu,*.ew,*.exu,*.exw  call dist#ft#EuphoriaCheck()
if has("fname_case")
   au BufNewFile,BufRead *.EU,*.EW,*.EX,*.EXU,*.EXW  call dist#ft#EuphoriaCheck()
endif

" Lynx config files
au BufNewFile,BufRead lynx.cfg			setf lynx

" Configure files
au BufNewFile,BufRead *.cfg			setf cfg

" Cucumber
au BufNewFile,BufRead *.feature			setf cucumber
" Dart
au BufRead,BufNewfile *.dart,*.drt		setf dart

" Debian Control
au BufNewFile,BufRead */debian/control		setf debcontrol
au BufNewFile,BufRead control
	\  if getline(1) =~ '^Source:'
	\|   setf debcontrol
	\| endif

" Debian Copyright
au BufNewFile,BufRead */debian/copyright	setf debcopyright
au BufNewFile,BufRead copyright
	\  if getline(1) =~ '^Format:'
	\|   setf debcopyright
	\| endif

" Debian Sources.list
au BufNewFile,BufRead */etc/apt/sources.list		setf debsources
au BufNewFile,BufRead */etc/apt/sources.list.d/*.list	setf debsources

" Deny hosts
au BufNewFile,BufRead denyhosts.conf		setf denyhosts

" dnsmasq(8) configuration files
au BufNewFile,BufRead */etc/dnsmasq.conf	setf dnsmasq

" Desktop files
au BufNewFile,BufRead *.desktop,.directory	setf desktop

" Dict config
au BufNewFile,BufRead dict.conf,.dictrc		setf dictconf

" Dictd config
au BufNewFile,BufRead dictd.conf		setf dictdconf

" Diff files
au BufNewFile,BufRead *.diff,*.rej		setf diff
au BufNewFile,BufRead *.patch
	\ if getline(1) =~ '^From [0-9a-f]\{40\} Mon Sep 17 00:00:00 2001$' |
	\   setf gitsendemail |
	\ else |
	\   setf diff |
	\ endif

" Dircolors
au BufNewFile,BufRead .dir_colors,.dircolors,*/etc/DIR_COLORS	setf dircolors

" DTD (Document Type Definition for XML)
au BufNewFile,BufRead *.dtd			setf dtd

" EditorConfig (close enough to dosini)
au BufNewFile,BufRead .editorconfig		setf dosini

" Expect
au BufNewFile,BufRead *.exp			setf expect

" Fetchmail RC file
au BufNewFile,BufRead .fetchmailrc		setf fetchmail

" FStab
au BufNewFile,BufRead fstab,mtab		setf fstab

" GDB command files
au BufNewFile,BufRead .gdbinit			setf gdb

" Git
au BufNewFile,BufRead COMMIT_EDITMSG,MERGE_MSG,TAG_EDITMSG 	setf gitcommit
au BufNewFile,BufRead *.git/config,.gitconfig,/etc/gitconfig 	setf gitconfig
au BufNewFile,BufRead */.config/git/config			setf gitconfig
au BufNewFile,BufRead .gitmodules,*.git/modules/*/config	setf gitconfig
if !empty($XDG_CONFIG_HOME)
  au BufNewFile,BufRead $XDG_CONFIG_HOME/git/config		setf gitconfig
endif
au BufNewFile,BufRead git-rebase-todo		setf gitrebase
au BufRead,BufNewFile .gitsendemail.msg.??????	setf gitsendemail
au BufNewFile,BufRead .msg.[0-9]*
      \ if getline(1) =~ '^From.*# This line is ignored.$' |
      \   setf gitsendemail |
      \ endif
au BufNewFile,BufRead *.git/*
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   setf git |
      \ endif

" GPG
au BufNewFile,BufRead */.gnupg/options		setf gpg
au BufNewFile,BufRead */.gnupg/gpg.conf		setf gpg
au BufNewFile,BufRead */usr/*/gnupg/options.skel setf gpg

" Gnuplot scripts
au BufNewFile,BufRead *.gpi			setf gnuplot

" Go (Google)
au BufNewFile,BufRead *.go			setf go

" Groovy
au BufNewFile,BufRead *.gradle,*.groovy		setf groovy

" Group file
au BufNewFile,BufRead */etc/group,*/etc/group-,*/etc/group.edit,*/etc/gshadow,*/etc/gshadow-,*/etc/gshadow.edit,*/var/backups/group.bak,*/var/backups/gshadow.bak  setf group

" GTK RC
au BufNewFile,BufRead .gtkrc,gtkrc		setf gtkrc

" Haskell
au BufNewFile,BufRead *.hs,*.hsc,*.hs-boot,*.hsig setf haskell
au BufNewFile,BufRead *.lhs			setf lhaskell
au BufNewFile,BufRead *.chs			setf chaskell
au BufNewFile,BufRead cabal.project		setf cabalproject
au BufNewFile,BufRead $HOME/.cabal/config	setf cabalconfig
au BufNewFile,BufRead cabal.config		setf cabalconfig

" Haste
au BufNewFile,BufRead *.ht			setf haste
au BufNewFile,BufRead *.htpp			setf hastepreproc

" Hercules
au BufNewFile,BufRead *.vc,*.ev,*.sum,*.errsum	setf hercules

" HEX (Intel)
au BufNewFile,BufRead *.hex,*.h32		setf hex

" Hollywood
au BufRead,BufNewFile *.hws			setf hollywood

" Tilde (must be before HTML)
au BufNewFile,BufRead *.t.html			setf tilde

" HTML (.shtml and .stm for server side)
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call dist#ft#FThtml()

" HTML with Ruby - eRuby
au BufNewFile,BufRead *.erb,*.rhtml		setf eruby

" HTML with M4
au BufNewFile,BufRead *.html.m4			setf htmlm4

" Some template.  Used to be HTML Cheetah.
au BufNewFile,BufRead *.tmpl			setf template

" Host config
au BufNewFile,BufRead */etc/host.conf		setf hostconf

" Hosts access
au BufNewFile,BufRead */etc/hosts.allow,*/etc/hosts.deny  setf hostsaccess

" IDL (Interface Description Language)
au BufNewFile,BufRead *.idl			call dist#ft#FTidl()

" Ipfilter
au BufNewFile,BufRead ipf.conf,ipf6.conf,ipf.rules	setf ipfilter

" .INI file for MSDOS
au BufNewFile,BufRead *.ini			setf dosini

" SysV Inittab
au BufNewFile,BufRead inittab			setf inittab

" Java
au BufNewFile,BufRead *.java,*.jav		setf java

" JavaCC
au BufNewFile,BufRead *.jj,*.jjt		setf javacc

" JavaScript, ECMAScript, ES module script, CommonJS script
au BufNewFile,BufRead *.js,*.javascript,*.es,*.mjs,*.cjs   setf javascript

" JavaScript with React
au BufNewFile,BufRead *.jsx			setf javascriptreact

" Java Server Pages
au BufNewFile,BufRead *.jsp			setf jsp

" Java Properties resource file (note: doesn't catch font.properties.pl)
au BufNewFile,BufRead *.properties,*.properties_??,*.properties_??_??	setf jproperties


" JSON
au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest	setf json

" JSON Patch (RFC 6902)
au BufNewFile,BufRead *.json-patch			setf json

" Jupyter Notebook is also json
au BufNewFile,BufRead *.ipynb				setf json

" JSONC
au BufNewFile,BufRead *.jsonc			setf jsonc

" KDE script
au BufNewFile,BufRead *.ks			setf kscript

" Kconfig
au BufNewFile,BufRead Kconfig,Kconfig.debug	setf kconfig

" LDAP LDIF
au BufNewFile,BufRead *.ldif			setf ldif

" Less
au BufNewFile,BufRead *.less			setf less

" Lex
au BufNewFile,BufRead *.lex,*.l,*.lxx,*.l++	setf lex

" Lisp (*.el = ELisp, *.cl = Common Lisp, *.jl = librep Lisp)
if has("fname_case")
  au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,*.L,.emacs,.sawfishrc setf lisp
else
  au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,.emacs,.sawfishrc setf lisp
endif

" Login access
au BufNewFile,BufRead */etc/login.access	setf loginaccess

" Login defs
au BufNewFile,BufRead */etc/login.defs		setf logindefs

" Lua
au BufNewFile,BufRead *.lua			setf lua

" Luarocks
au BufNewFile,BufRead *.rockspec		setf lua

" M4
au BufNewFile,BufRead *.m4
	\ if expand("<afile>") !~? 'html.m4$\|fvwm2rc' | setf m4 | endif

" Mail (for Elm, trn, mutt, muttng, rn, slrn, neomutt)
au BufNewFile,BufRead snd.\d\+,.letter,.letter.\d\+,.followup,.article,.article.\d\+,pico.\d\+,mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\},neomutt-*-\w\+,neomutt[[:alnum:]_-]\\\{6\},ae\d\+.txt,/tmp/SLRN[0-9A-Z.]\+,*.eml setf mail

" Mail aliases
au BufNewFile,BufRead */etc/mail/aliases,*/etc/aliases	setf mailaliases

" Mailcap configuration file
au BufNewFile,BufRead .mailcap,mailcap		setf mailcap

" Makefile
au BufNewFile,BufRead *[mM]akefile,*.mk,*.mak,*.dsp setf make

" Manpage
au BufNewFile,BufRead *.man			setf nroff

" Man config
au BufNewFile,BufRead */etc/man.conf,man.config	setf manconf

" Markdown
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md  setf markdown

" Mercurial (hg) commit file
au BufNewFile,BufRead hg-editor-*.txt		setf hgcommit

" Mercurial config (looks like generic config file)
au BufNewFile,BufRead *.hgrc,*hgrc		setf cfg

" Messages (logs mostly)
au BufNewFile,BufRead */log/{auth,cron,daemon,debug,kern,lpr,mail,messages,news/news,syslog,user}{,.log,.err,.info,.warn,.crit,.notice}{,.[0-9]*,-[0-9]*} setf messages

" Modconf
au BufNewFile,BufRead */etc/modules.conf,*/etc/modules,*/etc/conf.modules setf modconf

" Msql
au BufNewFile,BufRead *.msql			setf msql

" Mysql
au BufNewFile,BufRead *.mysql			setf mysql

" Mutt setup files (must be before catch *.rc)
au BufNewFile,BufRead */etc/Muttrc.d/*		call s:StarSetf('muttrc')

" Mutt setup file (also for Muttng)
au BufNewFile,BufRead Mutt{ng,}rc		setf muttrc

" Noemutt setup file
au BufNewFile,BufRead Neomuttrc			setf neomuttrc

" Netrc
au BufNewFile,BufRead .netrc			setf netrc

" Ninja file
au BufNewFile,BufRead *.ninja			setf ninja

" Packet filter conf
au BufNewFile,BufRead pf.conf			setf pf

" Pacman Config (close enough to dosini)
au BufNewFile,BufRead */etc/pacman.conf		setf dosini

" Pacman hooks
au BufNewFile,BufRead *.hook
	\ if getline(1) == '[Trigger]' |
	\   setf dosini |
	\ endif

" Pam conf
au BufNewFile,BufRead */etc/pam.conf			setf pamconf

" Pam environment
au BufNewFile,BufRead pam_env.conf,.pam_environment	setf pamenv


" Password file
au BufNewFile,BufRead */etc/passwd,*/etc/passwd-,*/etc/passwd.edit,*/etc/shadow,*/etc/shadow-,*/etc/shadow.edit,*/var/backups/passwd.bak,*/var/backups/shadow.bak setf passwd

" PDF
au BufNewFile,BufRead *.pdf			setf pdf

" Perl
if has("fname_case")
  au BufNewFile,BufRead *.pl,*.PL		call dist#ft#FTpl()
else
  au BufNewFile,BufRead *.pl			call dist#ft#FTpl()
endif
au BufNewFile,BufRead *.plx,*.al,*.psgi		setf perl

" Perl, XPM or XPM2
au BufNewFile,BufRead *.pm
	\ if getline(1) =~ "XPM2" |
	\   setf xpm2 |
	\ elseif getline(1) =~ "XPM" |
	\   setf xpm |
	\ else |
	\   setf perl |
	\ endif

" Perl POD
au BufNewFile,BufRead *.pod			setf pod

" Php, php3, php4, etc.
" Also Phtml (was used for PHP 2 in the past)
" Also .ctp for Cake template file
au BufNewFile,BufRead *.php,*.php\d,*.phtml,*.ctp	setf php

" PHP config
au BufNewFile,BufRead php.ini-*			setf dosini

" PO and PO template (GNU gettext)
au BufNewFile,BufRead *.po,*.pot		setf po

" Postfix main config
au BufNewFile,BufRead main.cf			setf pfmain

" PowerShell
au BufNewFile,BufRead	*.ps1,*.psd1,*.psm1,*.pssc	setf ps1
au BufNewFile,BufRead	*.ps1xml			setf ps1xml
au BufNewFile,BufRead	*.cdxml,*.psc1			setf xml

" Printcap and Termcap
au BufNewFile,BufRead *printcap
	\ let b:ptcap_type = "print" | setf ptcap
au BufNewFile,BufRead *termcap
	\ let b:ptcap_type = "term" | setf ptcap

" Procmail
au BufNewFile,BufRead .procmail,.procmailrc	setf procmail

" Google protocol buffers
au BufNewFile,BufRead *.proto			setf proto

" Protocols
au BufNewFile,BufRead */etc/protocols		setf protocols

" Pyrex
au BufNewFile,BufRead *.pyx,*.pxd		setf pyrex

" Python, Python Shell Startup and Python Stub Files
" Quixote (Python-based web framework)
au BufNewFile,BufRead *.py,*.pyw,.pythonstartup,.pythonrc  setf python
au BufNewFile,BufRead *.ptl,*.pyi,SConstruct		   setf python

" RCS file
au BufNewFile,BufRead *\,v			setf rcs

" Readline
au BufNewFile,BufRead .inputrc,inputrc		setf readline

" Registry for MS-Windows
au BufNewFile,BufRead *.reg
	\ if getline(1) =~? '^REGEDIT[0-9]*\s*$\|^Windows Registry Editor Version \d*\.\d*\s*$' | setf registry | endif

" R Help file
if has("fname_case")
  au BufNewFile,BufRead *.rd,*.Rd		setf rhelp
else
  au BufNewFile,BufRead *.rd			setf rhelp
endif

" R noweb file
if has("fname_case")
  au BufNewFile,BufRead *.Rnw,*.rnw,*.Snw,*.snw		setf rnoweb
else
  au BufNewFile,BufRead *.rnw,*.snw			setf rnoweb
endif

" R Markdown file
if has("fname_case")
  au BufNewFile,BufRead *.Rmd,*.rmd,*.Smd,*.smd		setf rmd
else
  au BufNewFile,BufRead *.rmd,*.smd			setf rmd
endif

" RSS looks like XML
au BufNewFile,BufRead *.rss				setf xml

" R reStructuredText file
if has("fname_case")
  au BufNewFile,BufRead *.Rrst,*.rrst,*.Srst,*.srst	setf rrst
else
  au BufNewFile,BufRead *.rrst,*.srst			setf rrst
endif

" Rexx, Rebol or R
au BufNewFile,BufRead *.r,*.R				call dist#ft#FTr()

" Resolv.conf
au BufNewFile,BufRead resolv.conf		setf resolv

" Relax NG Compact
au BufNewFile,BufRead *.rnc			setf rnc

" Relax NG XML
au BufNewFile,BufRead *.rng			setf rng

" Robots.txt
au BufNewFile,BufRead robots.txt		setf robots

" reStructuredText Documentation Format
au BufNewFile,BufRead *.rst			setf rst

" RTF
au BufNewFile,BufRead *.rtf			setf rtf

" Interactive Ruby shell
au BufNewFile,BufRead .irbrc,irbrc		setf ruby

" Ruby
au BufNewFile,BufRead *.rb,*.rbw		setf ruby

" RubyGems
au BufNewFile,BufRead *.gemspec			setf ruby

" Rackup
au BufNewFile,BufRead *.ru			setf ruby

" Bundler
au BufNewFile,BufRead Gemfile			setf ruby

" Ruby on Rails
au BufNewFile,BufRead *.builder,*.rxml,*.rjs	setf ruby

" Rantfile and Rakefile is like Ruby
au BufNewFile,BufRead [rR]antfile,*.rant,[rR]akefile,*.rake	setf ruby

" Rust
au BufNewFile,BufRead *.rs			setf rust

" Samba config
au BufNewFile,BufRead smb.conf			setf samba

" Sass
au BufNewFile,BufRead *.sass			setf sass

" Scala
au BufNewFile,BufRead *.scala,*.sc		setf scala

" SCSS
au BufNewFile,BufRead *.scss			setf scss

" sed
au BufNewFile,BufRead *.sed			setf sed

" svelte
au BufNewFile,BufRead *.svelte			setf svelte


" Services
au BufNewFile,BufRead */etc/services		setf services

" Setserial config
au BufNewFile,BufRead */etc/serial.conf		setf setserial

" SGML
au BufNewFile,BufRead *.sgm,*.sgml
	\ if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'linuxdoc' |
	\   setf sgmllnx |
	\ elseif getline(1) =~ '<!DOCTYPE.*DocBook' || getline(2) =~ '<!DOCTYPE.*DocBook' |
	\   let b:docbk_type = "sgml" |
	\   let b:docbk_ver = 4 |
	\   setf docbk |
	\ else |
	\   setf sgml |
	\ endif

" SGML catalog file
au BufNewFile,BufRead catalog			setf catalog

" Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
" Gentoo ebuilds, Arch Linux PKGBUILDs and Alpine Linux APKBUILDs are actually
" bash scripts.
" NOTE: Patterns ending in a star are further down, these have lower priority.
au BufNewFile,BufRead .bashrc,bashrc,bash.bashrc,.bash[_-]profile,.bash[_-]logout,.bash[_-]aliases,bash-fc[-.],*.ebuild,*.bash,*.eclass,PKGBUILD,APKBUILD call dist#ft#SetFileTypeSH("bash")
au BufNewFile,BufRead .kshrc,*.ksh call dist#ft#SetFileTypeSH("ksh")
au BufNewFile,BufRead */etc/profile,.profile,*.sh,*.env call dist#ft#SetFileTypeSH(getline(1))

" Shell script (Arch Linux) or PHP file (Drupal)
au BufNewFile,BufRead *.install
	\ if getline(1) =~ '<?php' |
	\   setf php |
	\ else |
	\   call dist#ft#SetFileTypeSH("bash") |
	\ endif

" Z-Shell script (patterns ending in a star further below)
au BufNewFile,BufRead .zprofile,*/etc/zprofile,.zfbfmarks  setf zsh
au BufNewFile,BufRead .zshrc,.zshenv,.zlogin,.zlogout,.zcompdump setf zsh
au BufNewFile,BufRead *.zsh			setf zsh

" Screen RC
au BufNewFile,BufRead .screenrc,screenrc	setf screen

" SLRN
au BufNewFile,BufRead .slrnrc			setf slrnrc
au BufNewFile,BufRead *.score			setf slrnsc

" Smalltalk (and TeX)
au BufNewFile,BufRead *.st			setf st
au BufNewFile,BufRead *.cls
	\ if getline(1) =~ '^%' |
	\  setf tex |
	\ elseif getline(1)[0] == '#' && getline(1) =~ 'rexx' |
	\  setf rexx |
	\ else |
	\  setf st |
	\ endif


" Spec (Linux RPM)
au BufNewFile,BufRead *.spec			setf spec

" Squid
au BufNewFile,BufRead squid.conf		setf squid

" SQL for Oracle Designer
au BufNewFile,BufRead *.tyb,*.typ,*.tyc,*.pkb,*.pks	setf sql

" SQL
au BufNewFile,BufRead *.sql			call dist#ft#SQL()

" OpenSSH configuration
au BufNewFile,BufRead ssh_config,*/.ssh/config		setf sshconfig
au BufNewFile,BufRead */etc/ssh/ssh_config.d/*.conf	setf sshconfig

" OpenSSH server configuration
au BufNewFile,BufRead sshd_config			setf sshdconfig
au BufNewFile,BufRead */etc/ssh/sshd_config.d/*.conf	setf sshdconfig

" Sysctl
au BufNewFile,BufRead */etc/sysctl.conf,*/etc/sysctl.d/*.conf	setf sysctl

" Systemd unit files
au BufNewFile,BufRead */systemd/*.{automount,dnssd,link,mount,netdev,network,nspawn,path,service,slice,socket,swap,target,timer}	setf systemd
" Systemd overrides
au BufNewFile,BufRead */etc/systemd/*.conf.d/*.conf	setf systemd
au BufNewFile,BufRead */etc/systemd/system/*.d/*.conf	setf systemd
au BufNewFile,BufRead */.config/systemd/user/*.d/*.conf	setf systemd
" Systemd temp files
au BufNewFile,BufRead */etc/systemd/system/*.d/.#*	setf systemd
au BufNewFile,BufRead */etc/systemd/system/.#*		setf systemd
au BufNewFile,BufRead */.config/systemd/user/*.d/.#*	setf systemd
au BufNewFile,BufRead */.config/systemd/user/.#*	setf systemd

" Synopsys Design Constraints
au BufNewFile,BufRead *.sdc			setf sdc

" Sudoers
au BufNewFile,BufRead */etc/sudoers,sudoers.tmp	setf sudoers

" SVG (Scalable Vector Graphics)
au BufNewFile,BufRead *.svg			setf svg

" Tads (or Nroff or Perl test file)
au BufNewFile,BufRead *.t
	\ if !dist#ft#FTnroff() && !dist#ft#FTperl() | setf tads | endif

" Tags
au BufNewFile,BufRead tags			setf tags

" Tcl (JACL too)
au BufNewFile,BufRead *.tcl,*.tk,*.itcl,*.itk,*.jacl	setf tcl

" Terminfo
au BufNewFile,BufRead *.ti			setf terminfo

" TeX
au BufNewFile,BufRead *.latex,*.sty,*.dtx,*.ltx,*.bbl	setf tex
au BufNewFile,BufRead *.tex			call dist#ft#FTtex()

" ConTeXt
au BufNewFile,BufRead *.mkii,*.mkiv,*.mkvi,*.mkxl,*.mklx   setf context

" Texinfo
au BufNewFile,BufRead *.texinfo,*.texi,*.txi	setf texinfo

" TeX configuration
au BufNewFile,BufRead texmf.cnf			setf texmf

" Tidy config
au BufNewFile,BufRead .tidyrc,tidyrc,tidy.conf	setf tidy

" tmux configuration
au BufNewFile,BufRead {.,}tmux*.conf		setf tmux

" TOML
au BufNewFile,BufRead *.toml			setf toml

" Tutor mode
au BufNewFile,BufReadPost *.tutor		setf tutor

" Typescript or Qt translation file (which is XML)
au BufNewFile,BufReadPost *.ts
	\ if getline(1) =~ '<?xml' |
	\   setf xml |
	\ else |
	\   setf typescript |
	\ endif

" TypeScript with React
au BufNewFile,BufRead *.tsx			setf typescriptreact

" Udev conf
au BufNewFile,BufRead */etc/udev/udev.conf	setf udevconf

" Udev permissions
au BufNewFile,BufRead */etc/udev/permissions.d/*.permissions setf udevperm
"
" Udev symlinks config
au BufNewFile,BufRead */etc/udev/cdsymlinks.conf	setf sh

" Updatedb
au BufNewFile,BufRead */etc/updatedb.conf	setf updatedb

" Upstart (init(8)) config files
au BufNewFile,BufRead */usr/share/upstart/*.conf	       setf upstart
au BufNewFile,BufRead */usr/share/upstart/*.override	       setf upstart
au BufNewFile,BufRead */etc/init/*.conf,*/etc/init/*.override  setf upstart
au BufNewFile,BufRead */.init/*.conf,*/.init/*.override	       setf upstart
au BufNewFile,BufRead */.config/upstart/*.conf		       setf upstart
au BufNewFile,BufRead */.config/upstart/*.override	       setf upstart

" Vera
au BufNewFile,BufRead *.vr,*.vri,*.vrh		setf vera

" Vim script
au BufNewFile,BufRead *.vim,*.vba,.exrc,_exrc	setf vim

" Viminfo file
au BufNewFile,BufRead .viminfo,_viminfo		setf viminfo

" Visual Basic (also uses *.bas) or FORM
au BufNewFile,BufRead *.frm			call dist#ft#FTVB("form")


" Vroom (vim testing and executable documentation)
au BufNewFile,BufRead *.vroom			setf vroom

" Vue.js Single File Component
au BufNewFile,BufRead *.vue			setf vue

" WebAssembly
au BufNewFile,BufRead *.wast,*.wat		setf wast

" Webmacro
au BufNewFile,BufRead *.wm			setf webmacro

" Wget config
au BufNewFile,BufRead .wgetrc,wgetrc		setf wget

" Website MetaLanguage
au BufNewFile,BufRead *.wml			setf wml

" CVS RC file
au BufNewFile,BufRead .cvsrc			setf cvsrc

" CVS commit file
au BufNewFile,BufRead cvs\d\+			setf cvs

" Windows Scripting Host and Windows Script Component
au BufNewFile,BufRead *.ws[fc]			setf wsh

" XHTML
au BufNewFile,BufRead *.xhtml,*.xht		setf xhtml

" X Pixmap (dynamically sets colors, use BufEnter to make it work better)
au BufEnter *.xpm
	\ if getline(1) =~ "XPM2" |
	\   setf xpm2 |
	\ else |
	\   setf xpm |
	\ endif
au BufEnter *.xpm2				setf xpm2

" XFree86 config
au BufNewFile,BufRead XF86Config
	\ if getline(1) =~ '\<XConfigurator\>' |
	\   let b:xf86conf_xfree86_version = 3 |
	\ endif |
	\ setf xf86conf
au BufNewFile,BufRead */xorg.conf.d/*.conf
	\ let b:xf86conf_xfree86_version = 4 |
	\ setf xf86conf

" Xorg config
au BufNewFile,BufRead xorg.conf,xorg.conf-4	let b:xf86conf_xfree86_version = 4 | setf xf86conf

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.conf		setf xinetd

" X resources file
au BufNewFile,BufRead .Xdefaults,.Xpdefaults,.Xresources,xdm-config,*.ad setf xdefaults

" Xmath
au BufNewFile,BufRead *.msc,*.msf		setf xmath
au BufNewFile,BufRead *.ms
	\ if !dist#ft#FTnroff() | setf xmath | endif

" XML  specific variants: docbk and xbl
au BufNewFile,BufRead *.xml			call dist#ft#FTxml()

" XMI (holding UML models) is also XML
au BufNewFile,BufRead *.xmi			setf xml

" CSPROJ files are Visual Studio.NET's XML-based project config files
au BufNewFile,BufRead *.csproj,*.csproj.user	setf xml

" Qt Linguist translation source and Qt User Interface Files are XML
" However, for .ts Typescript is more common.
au BufNewFile,BufRead *.ui			setf xml

" Xdg menus
au BufNewFile,BufRead */etc/xdg/menus/*.menu	setf xml

" XML User Interface Language
au BufNewFile,BufRead *.xul			setf xml

" X11 xmodmap (also see below)
au BufNewFile,BufRead *Xmodmap			setf xmodmap

" Xquery
au BufNewFile,BufRead *.xq,*.xql,*.xqm,*.xquery,*.xqy	setf xquery

" XSD
au BufNewFile,BufRead *.xsd			setf xsd

" Xslt
au BufNewFile,BufRead *.xsl,*.xslt		setf xslt

" Yacc
au BufNewFile,BufRead *.yy,*.yxx,*.y++		setf yacc

" Yacc or racc
au BufNewFile,BufRead *.y			call dist#ft#FTy()

" Yaml
au BufNewFile,BufRead *.yaml,*.yml		setf yaml

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.conf		setf dosini

" Check for "*" after loading myfiletypefile, so that scripts.vim is only used
" when there are no matching file name extensions.
" Don't do this for compressed files.
augroup filetypedetect
au BufNewFile,BufRead *
	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
	\ | runtime! scripts.vim | endif
au StdinReadPost * if !did_filetype() | runtime! scripts.vim | endif


" Extra checks for when no filetype has been detected now.  Mostly used for
" patterns that end in "*".  E.g., "zsh*" matches "zsh.vim", but that's a Vim
" script file.
" Most of these should call s:StarSetf() to avoid names ending in .gz and the
" like are used.

" More Apache style config files
au BufNewFile,BufRead */etc/proftpd/*.conf*,*/etc/proftpd/conf.*/*	call s:StarSetf('apachestyle')
au BufNewFile,BufRead proftpd.conf*					call s:StarSetf('apachestyle')

" More Apache config files
au BufNewFile,BufRead access.conf*,apache.conf*,apache2.conf*,httpd.conf*,srm.conf*	call s:StarSetf('apache')
au BufNewFile,BufRead */etc/apache2/*.conf*,*/etc/apache2/conf.*/*,*/etc/apache2/mods-*/*,*/etc/apache2/sites-*/*,*/etc/httpd/conf.d/*.conf*		call s:StarSetf('apache')

" BIND zone
au BufNewFile,BufRead */named/db.*,*/bind/db.*	call s:StarSetf('bindzone')

au BufNewFile,BufRead cabal.project.*		call s:StarSetf('cabalproject')

" Changelog
au BufNewFile,BufRead [cC]hange[lL]og*
	\ if getline(1) =~ '; urgency='
	\|  call s:StarSetf('debchangelog')
	\|else
	\|  call s:StarSetf('changelog')
	\|endif

" Crontab
au BufNewFile,BufRead crontab,crontab.*,*/etc/cron.d/*		call s:StarSetf('crontab')

" dnsmasq(8) configuration
au BufNewFile,BufRead */etc/dnsmasq.d/*		call s:StarSetf('dnsmasq')

" Git
au BufNewFile,BufRead */.gitconfig.d/*,/etc/gitconfig.d/*	call s:StarSetf('gitconfig')

" GTK RC
au BufNewFile,BufRead .gtkrc*,gtkrc*		call s:StarSetf('gtkrc')

" Java Properties resource file (note: doesn't catch font.properties.pl)
au BufNewFile,BufRead *.properties_??_??_*	call s:StarSetf('jproperties')

" Kconfig
au BufNewFile,BufRead Kconfig.*			call s:StarSetf('kconfig')

" Makefile
au BufNewFile,BufRead [mM]akefile*		call s:StarSetf('make')

" Ruby Makefile
au BufNewFile,BufRead [rR]akefile*		call s:StarSetf('ruby')

" Mail (also matches muttrc.vim, so this is below the other checks)
au BufNewFile,BufRead {neo,}mutt[[:alnum:]._-]\\\{6\}	setf mail

au BufNewFile,BufRead reportbug-*		call s:StarSetf('mail')

" Modconf
au BufNewFile,BufRead */etc/modutils/*
	\ if executable(expand("<afile>")) != 1
	\|  call s:StarSetf('modconf')
	\|endif
au BufNewFile,BufRead */etc/modprobe.*		call s:StarSetf('modconf')

" Mutt setup file
au BufNewFile,BufRead .mutt{ng,}rc*,*/.mutt{ng,}/mutt{ng,}rc*	call s:StarSetf('muttrc')
au BufNewFile,BufRead mutt{ng,}rc*,Mutt{ng,}rc*		call s:StarSetf('muttrc')

" Neomutt setup file
au BufNewFile,BufRead .neomuttrc*,*/.neomutt/neomuttrc*	call s:StarSetf('neomuttrc')
au BufNewFile,BufRead neomuttrc*,Neomuttrc*		call s:StarSetf('neomuttrc')

" Pam conf
au BufNewFile,BufRead */etc/pam.d/*		call s:StarSetf('pamconf')

" Printcap and Termcap
au BufNewFile,BufRead *printcap*
	\ if !did_filetype()
	\|  let b:ptcap_type = "print" | call s:StarSetf('ptcap')
	\|endif
au BufNewFile,BufRead *termcap*
	\ if !did_filetype()
	\|  let b:ptcap_type = "term" | call s:StarSetf('ptcap')
	\|endif

" avoid doc files being recognized a shell files
au BufNewFile,BufRead */doc/{,.}bash[_-]completion{,.d,.sh}{,/*} setf text

" Shell scripts ending in a star
au BufNewFile,BufRead .bashrc*,.bash[_-]profile*,.bash[_-]logout*,.bash[_-]aliases*,bash-fc[-.]*,PKGBUILD*,APKBUILD*,*/{,.}bash[_-]completion{,.d,.sh}{,/*} call dist#ft#SetFileTypeSH("bash")
au BufNewFile,BufRead .kshrc* call dist#ft#SetFileTypeSH("ksh")
au BufNewFile,BufRead .profile* call dist#ft#SetFileTypeSH(getline(1))

" Vim script
au BufNewFile,BufRead *vimrc*			call s:StarSetf('vim')

" Subversion commit file
au BufNewFile,BufRead svn-commit*.tmp		setf svn

" X resources file
au BufNewFile,BufRead Xresources*,*/app-defaults/*,*/Xresources/* call s:StarSetf('xdefaults')

" XFree86 config
au BufNewFile,BufRead XF86Config-4*
	\ let b:xf86conf_xfree86_version = 4 | call s:StarSetf('xf86conf')
au BufNewFile,BufRead XF86Config*
	\ if getline(1) =~ '\<XConfigurator\>'
	\|  let b:xf86conf_xfree86_version = 3
	\|endif
	\|call s:StarSetf('xf86conf')

" X11 xmodmap
au BufNewFile,BufRead *xmodmap*			call s:StarSetf('xmodmap')

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.d/*		call s:StarSetf('xinetd')

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.repos.d/*	call s:StarSetf('dosini')

" Z-Shell script ending in a star
au BufNewFile,BufRead .zsh*,.zlog*,.zcompdump*  call s:StarSetf('zsh')
au BufNewFile,BufRead zsh*,zlog*		call s:StarSetf('zsh')


" Plain text files, needs to be far down to not override others.  This avoids
" the "conf" type being used if there is a line starting with '#'.
au BufNewFile,BufRead *.text,README setf text

" Help files match *.txt but should have a last line that is a modeline. 
au BufNewFile,BufRead *.txt
        \  if getline('$') !~ 'vim:.*ft=help'
        \|   setf text
        \| endif       

" Use the filetype detect plugins.  They may overrule any of the previously
" detected filetypes.
runtime! ftdetect/*.vim
runtime! ftdetect/*.lua

" NOTE: The above command could have ended the filetypedetect autocmd group
" and started another one. Let's make sure it has ended to get to a consistent
" state.
augroup END

" Generic configuration file. Use FALLBACK, it's just guessing!
au filetypedetect BufNewFile,BufRead,StdinReadPost *
	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
	\    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
	\	|| getline(4) =~ '^#' || getline(5) =~ '^#') |
	\   setf FALLBACK conf |
	\ endif


" If the GUI is already running, may still need to install the Syntax menu.
" Don't do it when the 'M' flag is included in 'guioptions'.
if has("menu") && has("gui_running")
      \ && !exists("did_install_syntax_menu") && &guioptions !~# "M"
  source <sfile>:p:h/menu.vim
endif

" Function called for testing all functions defined here.  These are
" script-local, thus need to be executed here.
" Returns a string with error messages (hopefully empty).
func! TestFiletypeFuncs(testlist)
  let output = ''
  for f in a:testlist
    try
      exe f
    catch
      let output = output . "\n" . f . ": " . v:exception
    endtry
  endfor
  return output
endfunc

" Restore 'cpoptions'
let &cpo = s:cpo_save
unlet s:cpo_save
