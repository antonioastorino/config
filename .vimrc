" Resource:
" https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot
" https://stackoverflow.com/questions/45502128/vim-spell-highlighting
set nocompatible
let mapleader = " "

so ~/config/mapping.vim
so ~/config/settings.vim

autocmd BufNewFile,BufRead *.html,*.js setlocal tabstop=2 shiftwidth=2 softtabstop=2

let s:clang_list = ["c","cpp","m","mm","h","hh","hpp","ino"]
let s:prettier_list = ["css","html","json","js"]

function! MakeTags()
    silent !ctags -R .
    :redraw!
endfunction

function! ToggleComment()
    let l:extension = expand('%:e')
    let s:pattern = ''
    if index(s:clang_list, l:extension) >= 0
        let s:pattern = '\/\/'
    elseif l:extension == "sh"
        let s:pattern = "#"
    elseif l:extension == "py"
        let s:pattern = "#"
    elseif l:extension == "js"
        let s:pattern = '\/\/'
    endif
    if (s:pattern == '')
        :echo "Cannot comment: file extension '.".l:extension."' not supported yet"
        return
    endif
    if (col('$') == 1) " this is an empty line - skip
        return
    endif
    execute "norm! mb"
    try
        " Try to uncomment
        :execute 's/^\s*' . s:pattern . '//'
    catch
        " Uncommenting failed - comment
        :execute 's/^/' . s:pattern . '/'
    endtry
    execute "norm! `b"
endfunction

function! Format()
    let l:extension = expand('%:e')
    " Save the file, pass it to clang-format
    if index(s:clang_list, l:extension) >= 0
        let $format_style = join(readfile($HOME."/config/.clang-format"))
        silent! w | w !clang-format --style=$format_style > %
    elseif index(s:prettier_list, l:extension) >= 0
        silent! w | w !npx prettier --config $HOME/config/.prettierrc.json --write %
    elseif l:extension == "sh"
        w | w !shfmt -i 4 > fmttmp.tmp
        if (v:shell_error)
            !echo "Failed to format shell script."
        else
            silent !cat fmttmp.tmp > %
            :retab
        endif
        silent !rm fmttmp.tmp
        edraw!
    elseif l:extension == "py"
        silent! w | w !python3 -m autopep8 --in-place --aggressive --aggressive --max-line-length 100 %
     elseif l:extension == "rs"
        w | w !rustfmt %
    else
        :echo "Cannot format: file extension '.".l:extension."' not supported yet"
    endif
endfunction

function! GitDiff()
    :silent write
    :silent execute '!git d --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

function! ToggleHunkPreview()
    if gitgutter#hunk#is_preview_window_open()
        :pclose
    else
        GitGutterPreviewHunk
    endif
endfunction

function! FindLocal()
    let s:wordUnderCursor = expand("<cword>")
    " Close the navigation window if already open.
    :cclose
    :execute 'vimgrep /\<'.s:wordUnderCursor.'\>/g %'
endfunction

function! FindGlobal()
    let s:wordUnderCursor = expand("<cword>")
    :execute 'vimgrep /\<'.s:wordUnderCursor.'\>/g `fd -H --ignore-file .gitignore -E ".git"`'
    " Open the navigation window.
    :copen
    " Move cursor to the window in which the search was launched.
    :execute "norm! \<C-W>p"
endfunction

function! Autocomplete()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction

let s:term_buf_nr = -1
function! ToggleTerminal() abort
    if s:term_buf_nr == -1
        execute "terminal"
        execute "norm! \<C-W>L"
        let s:term_buf_nr = bufnr("$")
    else
        try
            execute "bdelete! " . s:term_buf_nr
        catch
            let s:term_buf_nr = -1
            call <SID>ToggleTerminal()
            return
        endtry
        let s:term_buf_nr = -1
    endif
endfunction


