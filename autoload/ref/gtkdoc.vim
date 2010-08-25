" A ref source for gtkdoc.
" Version: 0.0.1
" Author : eiiches <sato.eiichi+github@gmail.com>
"        : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

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

let &cpo = s:save_cpo
unlet s:save_cpo
