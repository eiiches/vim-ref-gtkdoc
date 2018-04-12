" A ref source for gtkdoc.
" Version: 0.0.1
" Author : eiiches <sato.eiichi+github@gmail.com>
"        : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ref_gtkdoc_cmd')
	let g:ref_gtkdoc_cmd = globpath(&rtp, 'gtkdoc/gtkdoc', 1)
endif

let s:source = {'name': 'gtkdoc'}  " {{{1

function! s:source.available()  " {{{2
  return !empty(g:ref_gtkdoc_cmd)
endfunction

function! s:source.get_body(query)  " {{{2
  return ref#system(g:ref_gtkdoc_cmd.' '.a:query).stdout
endfunction

function! s:source.opened(query)  " {{{2
  execute "normal! gg"
  call s:syntax(a:query)
endfunction

function! s:source.normalize(query)  " {{{2
  return substitute(substitute(a:query, '\_s\+', ' ', 'g'), '^ \| $', '', 'g')
endfunction

" misc. {{{1
function! s:syntax(query)  " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-gtkdoc'
    return
  endif

  syntax clear
  let str = escape(substitute(a:query, '\s\+', '\\_s\\+', 'g'), '"')
  if str =~# '^[[:alnum:]_[:space:]]\+$'
    let str = '\<' . str . '\>'
		execute 'syntax match refGtkDocKeyword "\c'.str.'"'
		highlight default link refGtkDocKeyword Special
  endif
endfunction

function! ref#gtkdoc#define()  " {{{2
  return s:source
endfunction

function! ref#gtkdoc#vsel()  " {{{2
  if "vV" =~ mode()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    let patter = join(lines)
  else
    let pattern = expand("<cword>")
  endif

  call ref#ref('gtkdoc ' . pattern)

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
