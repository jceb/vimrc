" math.vim:		Mathematical functions
" directory
" Last Modified: Sun 16. May 2010 17:38:23 +0200 CEST
" Author:		Jan Christoph Ebersbach <jceb@e-jc.de>
" Version:		0.1

if (exists("g:loaded_math") && g:loaded_math) || &cp
    finish
endif
let g:loaded_math = 1

" The function Nr2Hex() returns the Hex string of a number.
function! Nr2Hex(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile
	return r
endfunction

" The function String2Hex() converts each character in a string to a two
" character Hex string.
function! String2Hex(str)
	let out = ''
	let ix = 0
	while ix < strlen(a:str)
		let out = out . Nr2Hex(char2nr(a:str[ix]))
		let ix = ix + 1
	endwhile
	return out
endfunction

" translates hex value to the corresponding number
function! Hex2Nr(hex)
	let r = 0
	let ix = strlen(a:hex) - 1
	while ix >= 0
		let val = 0
		if a:hex[ix] == '1'
			let val = 1
		elseif a:hex[ix] == '2'
			let val = 2
		elseif a:hex[ix] == '3'
			let val = 3
		elseif a:hex[ix] == '4'
			let val = 4
		elseif a:hex[ix] == '5'
			let val = 5
		elseif a:hex[ix] == '6'
			let val = 6
		elseif a:hex[ix] == '7'
			let val = 7
		elseif a:hex[ix] == '8'
			let val = 8
		elseif a:hex[ix] == '9'
			let val = 9
		elseif a:hex[ix] == 'a' || a:hex[ix] == 'A'
			let val = 10
		elseif a:hex[ix] == 'b' || a:hex[ix] == 'B'
			let val = 11
		elseif a:hex[ix] == 'c' || a:hex[ix] == 'C'
			let val = 12
		elseif a:hex[ix] == 'd' || a:hex[ix] == 'D'
			let val = 13
		elseif a:hex[ix] == 'e' || a:hex[ix] == 'E'
			let val = 14
		elseif a:hex[ix] == 'f' || a:hex[ix] == 'F'
			let val = 15
		endif
		let r = r + val * Power(16, strlen(a:hex) - ix - 1)
		let ix = ix - 1
	endwhile
	return r
endfunction

" mathematical power function
function! Power(base, exp)
	let r = 1
	let exp = a:exp
	while exp > 0
		let r = r * a:base
		let exp = exp - 1
	endwhile
	return r
endfunction

