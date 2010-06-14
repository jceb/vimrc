" cdargs.vim - Directory bookmarking based on CDargs
" Author: Chris Gaffney
" GetLatestVimScripts: 2466 1 :AutoInstall: cdargs.vim
" URL:    http://github.com/gaffneyc/vim-cdargs
" VimURL: http://www.vim.org/scripts/script.php?script_id=2466
" CDargs: http://www.skamphausen.de/cgi-bin/ska/CDargs

" Commands
"   Cdb - Change directory to bookmark
"   Eb  - Edit file in bookmark directory
"   Tb  - Similar to Eb but edit the file in a new tab

" History
"   1.0
"     Initial Release
"
"   1.1
"     Added Tb command
"     Refactored command execution
"
"   1.2
"     Fix bookmarks that have a space in their path
"     Better error handling if a subpath cannot be found

" Todo
"   - Figure out bang commands
"   - Make completion functions and execute global(?)

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set
if &cp || (exists('g:loaded_cdargs') && g:loaded_cdargs)
  finish
endif
let g:loaded_cdargs = 1

" What file to read
let s:cdargs_file = $HOME . '/.cdargs'

" Bookmark caching
let s:cached_bookmarks = {}
let s:cdargs_file_mod_time = 0

function! s:error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
  let v:errmsg = a:str
endfunction

" Might be a good idea to check if .cdargs exists and is readable.
" Raise an error if isn't. An empty bookmarks file should still be an
" empty dictionary.
"
" NOTES:
"   filereadable(file)  => Is file readable
function! s:bookmarks()
  " Check to see if the bookmarks definition file has been updated
  if s:cdargs_file_mod_time == getftime(s:cdargs_file)
    return s:cached_bookmarks
  endif

  let l:bookmarks = {}

  " Parse the bookmark definition file
  for line in readfile(s:cdargs_file)
    let l:idx = stridx(line, " ")

    let l:bookmark = strpart(line, 0, l:idx)
    let l:path     = strpart(line, l:idx + 1)

    let l:bookmarks[l:bookmark] = s:trim_trailing_slash(l:path)
  endfor

  " Update the cache and it's modification time
  let s:cached_bookmarks = l:bookmarks
  let s:cdargs_file_mod_time = getftime(s:cdargs_file)

  return l:bookmarks
endfunction

" Match a bookmark then match any directory under that bookmark
"
" 1. Complete on the bookmark
" 2. Once we have a matched bookmark then matched directories / files
"    based on the associated path
"
" With bookmarks: [ "midstate", "phantom", "phoenix" ]
"   Bookmark completion:
"   ""             => [ "midstate/", "phantom/", "phoenix/" ]
"   "ph"           => [ "phantom/", "phoenix/" ]
"   "phoenix"      => [ "phoenix/" ]
"   Path completion:
"   "phoenix/"     => [ "phoenix/app/", "phoenix/test/", ... ]
"   "phoenix/app"  => [ "phoenix/app/" ]
"   "phoenix/app/" => [ "phoenix/app/controllers/", "phoenix/app/models/" ]
function! s:bookmark_completion(argument, show_files)
  let [ l:bookmark, l:subpath ] = s:parse_bookmark_and_path(a:argument)

  let l:bookmarks = s:bookmarks()

  if has_key(l:bookmarks, l:bookmark)
    " Path completion
    let l:matched = []
    let l:path = get(l:bookmarks, l:bookmark)
    let l:files = split(globpath(l:path, l:subpath . '*'), "\n")

    for file in l:files
      " Filter out files if necessary
      if !a:show_files && !isdirectory(file)
        continue
      endif

      " Cut the path down to just that after the bookmark
      let trimmed = s:trim_leading_slash(file[strlen(l:path):])

      " Ignore any files that don't matched the given subpath
      if strlen(l:subpath) && match(trimmed, '^' . l:subpath) == -1
        continue
      end

      " Directories are designated by a trailing slash
      if isdirectory(file)
        let trimmed = s:ensure_trailing_slash(trimmed)
      endif

      call add(l:matched, l:bookmark . '/' . trimmed)
    endfor

    return l:matched
  else
    " Bookmark completion
    let l:matched = []

    for bookmark in keys(l:bookmarks)
      if match(bookmark, "^" . a:argument) >= 0
        call add(l:matched, bookmark . '/')
      endif
    endfor

    return matched
  endif
endfunction

function! s:trim_leading_slash(path)
  return a:path[0] == '/' ? a:path[1:] : a:path
endfunction

function! s:trim_trailing_slash(path)
  return a:path[-1:] == '/' ? a:path[:-2] : a:path
endfunction

function! s:ensure_trailing_slash(path)
  return a:path[-1:] == '/' ? a:path : a:path . '/'
endfunction

" Custom list completion that shows only directories
function! s:directory_completion(ArgLead, CmdLine, CursorPos)
  return s:bookmark_completion(a:ArgLead, 0)
endfunction

" Custom list completion that shows files and directories
function! s:file_completion(ArgLead, CmdLine, CursorPos)
  return s:bookmark_completion(a:ArgLead, 1)
endfunction

" ...
"
" ""              => [ "", ""]
" "/"             => [ "", "" ]
" "/abc"          => [ "", "" ]
" "ph"            => [ "ph", "" ]
" "ph/"           => [ "ph", "" ]
" "ph/app"        => [ "ph", "app" ]
" "ph/app/"       => [ "ph", "app/" ]
" "ph/app/models" => [ "ph", "app/models" ]
function! s:parse_bookmark_and_path(raw)
  let l:idx = stridx(a:raw, '/')

  " No valid slash so always return [ bookmark, '' ]
  if l:idx < 0
    return [ a:raw, '']
  elseif l:idx == 0
    return [ '', '' ]
  endif

  " Valid slash
  let l:bookmark = a:raw[:l:idx - 1]
  let l:path = a:raw[l:idx + 1:]

  return [ l:bookmark , l:path ]
endfunction

function! s:path_for(raw)
  let [ l:bookmark, l:subpath ] = s:parse_bookmark_and_path(a:raw)
  let l:path = get(s:bookmarks(), l:bookmark, '')

  if strlen(l:path)
    return s:ensure_trailing_slash(l:path) . l:subpath
  else
    call s:error('Could not find bookmark: ' . l:bookmark)
    return ''
  end
endfunction

function! s:execute(command, raw)
  " Escape spaces in the path
  let l:path = substitute(s:path_for(a:raw), " ", '\\ ', "g")

  if strlen(l:path)
    try
      execute a:command . ' ' . l:path
    catch
      call s:error('Unable to find path: ' . l:path)
    endtry
  end
endfunction

" Change working directory to bookmark or it's subpath
command! -nargs=1 -complete=customlist,s:directory_completion Cdb call s:execute('cd', <f-args>)

" Edit file under a bookmark's path
command! -nargs=1 -complete=customlist,s:file_completion Eb call s:execute('edit', <f-args>)

" Edit file under a bookmark's path in a new tab
command! -nargs=1 -complete=customlist,s:file_completion Tb call s:execute('tabedit', <f-args>)
