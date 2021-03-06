if exists('g:loaded_ctrlp_register') && g:loaded_ctrlp_register
  finish
endif
let g:loaded_ctrlp_register = 1

let s:register_var = {
\  'init':   'ctrlp#register#init()',
\  'exit':   'ctrlp#register#exit()',
\  'accept': 'ctrlp#register#accept',
\  'lname':  'register',
\  'sname':  'register',
\  'type':   'register',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:register_var)
else
  let g:ctrlp_ext_vars = [s:register_var]
endif

function! ctrlp#register#init()
  let s = ''
  redir => s
  silent registers
  redir END
  let list = split(s, "\n")[1:]
  return ctrlp#register#unique(ctrlp#register#trim(list))
endfunc

function! ctrlp#register#trim(l)
  let res = []
  for item in a:l
    let trimmed = substitute(item, "^\\s\\+\\|\\s\\+$","","g")
    call add(res, trimmed)
  endfor
  return res
endfunc

function! ctrlp#register#unique(list, ...)
  let dictionary = {}
  for i in a:list
    let dictionary[string(i)] = i
  endfor
  let result = []
  if ( exists( 'a:1' ) )
    let result = sort( values( dictionary ), a:1 )
  else
    let result = sort( values( dictionary ) )
  endif
  return result
endfunc

function! ctrlp#register#accept(mode, str)
  call ctrlp#exit()
	exe "normal! ".matchstr(a:str, '^\S\+\ze.*')."p"
endfunction

function! ctrlp#register#exit()
endfunc

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#register#id()
  return s:id
endfunc

" vim:fen:fdl=0:ts=2:sw=2:sts=2
