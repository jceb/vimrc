" get javascript lint at http://www.javascriptlint.com/
set makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -conf\ '/etc/jsl.conf'\ -process\ %:p
set errorformat=%f(%l):\ %m
