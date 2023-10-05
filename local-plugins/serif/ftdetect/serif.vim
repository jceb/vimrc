autocmd BufNewFile,BufRead *.serif setlocal filetype=serif commentstring=#%s comments=b:#\|,b:# errorformat=%Eerror\ in\ file:\ %f,%ZError:\ %m\ at\ %l:%c makeprg=serif-compile\ %
