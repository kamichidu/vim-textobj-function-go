" The MIT License (MIT)
"
" Copyright (c) 2015 kamichidu
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
function! textobj#function#go#select(object_type) abort
    return s:select_{a:object_type}()
endfunction

function! s:select_a() abort
    " find ``func (xxx YYY) zzz(...) aaa {''
    while getline('.') !~# 'func\s\+\%(([^)]\+)\s\+\)\?\w\+([^)]*)\s*\%(\%(\w\|\*\)\+\|([^)]\+)\)\?\s*{'
        let before= getpos('.')
        keepjumps normal! [{
        if getpos('.') ==# before
            return 0
        endif
    endwhile
    keepjumps normal! 0
    let begin= getpos('.')

    keepjumps normal! f{%
    let end= getpos('.')

    if 0 <= end[1] - begin[1]  " is there some code?
        return ['v', begin, end]
    else
        return 0
    endif
endfunction

function! s:select_i() abort
    let range = s:select_a()
    if range is 0
        return 0
    endif

    let [_, ab, ae] = range

    call setpos('.', ab)
    keepjumps normal! f{j0
    let ib = getpos('.')

    call setpos('.', ae)
    normal! k$
    let ie = getpos('.')

    if 0 <= ie[1] - ib[1]  " is there some code?
        return ['v', ib, ie]
    else
        return 0
    endif
endfunction
