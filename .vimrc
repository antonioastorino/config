" Resource:
" https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot
" https://stackoverflow.com/questions/45502128/vim-spell-highlighting

"---- settings start ----
set exrc
set nocompatible
let mapleader = " "
syntax on
set background=dark
filetype plugin on
set path+=**
set wildmenu
set autoindent
set number relativenumber
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set autoread
set ruler
set showmatch
set splitbelow splitright
set scrolloff=5
set backspace=indent,eol,start
set hlsearch
set complete-=i

" fix hanging when opening .ts files
" (https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file)
autocmd BufNewFile,BufReadPre *.ts setlocal re=2
autocmd BufNewFile,BufRead *.html,*.js,*.ts,*.swift setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd TerminalOpen * set nonu nornu
autocmd FileType c,cpp,python,rust,zig,typescript setlocal omnifunc=lsp#complete

" Generic syntax highlights
hi Statement  ctermfg=Gray        cterm=bold             
hi Identifier ctermfg=Gray        cterm=none
hi String     ctermfg=LightBlue   cterm=none
hi Type       ctermfg=Cyan        cterm=none   
hi Comment    ctermfg=DarkGreen   ctermbg=none cterm=none
hi Constant   ctermfg=Yellow      cterm=bold
hi SpecialKey ctermfg=Blue        cterm=bold

" GitGutter
set updatetime=100
let g:gitgutter_enabled = 1
highlight GitGutterAdd    ctermfg=Green  ctermbg=Blue
highlight GitGutterChange ctermfg=Yellow ctermbg=Green
highlight GitGutterDelete ctermfg=Red    ctermbg=Yellow
highlight SignColumn      ctermbg=Black
let g:gitgutter_sign_added                   = '++'
let g:gitgutter_sign_modified                = '~~'
let g:gitgutter_sign_removed                 = '__'
let g:gitgutter_sign_removed_first_line      = '^^'
let g:gitgutter_sign_removed_above_and_below = '_^'
let g:gitgutter_sign_modified_removed        = '~_'

" Cursor
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"
highlight CursorLine   cterm=NONE ctermbg=236
highlight Visual       ctermbg=green ctermfg=blue
autocmd VimEnter    * setlocal cursorline
autocmd WinEnter    * setlocal cursorline
autocmd BufWinEnter * setlocal cursorline
autocmd FocusGained * setlocal cursorline
autocmd WinLeave    * setlocal nocursorline
autocmd FocusLost   * setlocal nocursorline

" Spell checker - CamelCase is not a misspelled word
autocmd FileType markdown,text setlocal spell spelllang=en_us
set spelloptions=camel
highlight clear SpellBad
highlight SpellBad cterm=underline
highlight clear SpellRare
highlight SpellRare cterm=underline
highlight clear SpellCap
highlight SpellCap cterm=underline
highlight clear SpellLocal
highlight SpellLocal cterm=underline
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE
highlight Search ctermfg=Grey ctermbg=DarkGrey

" Syntax highlight
let g:cpp_function_highlight = 1
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
let g:cpp_type_name_highlight = 1
let g:cpp_operator_highlight = 1

" --- LSP --- start
let g:lsp_completion_enabled = 0
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--background-index', '--completion-style=detailed']},
        \ 'allowlist': ['c', 'cpp'],
    \ })
endif
let g:lsp_diagnostics_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_settings = {
\ 'pylsp': {
\   'plugins': {
\     'pycodestyle': {'enabled': v:false},
\     'rope_completion': {'enabled': v:false},
\   }
\ }
\}
call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp'],
    \ })
endif

" sudo apt install python3-pylsp
if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
    \ })
endif
autocmd FileType c,cpp,python setlocal omnifunc=lsp#complete

" --- LSP end ---
"---- settings end ----
"
"---- mapping start ----
inoremap jk <esc>
inoremap <esc> <nop>

" Code-specific
inoremap <c-f> <esc>:call Format()<cr>
nnoremap <c-f> :call Format()<cr>
inoremap <c-x> <esc>:call ToggleComment()<cr>
nnoremap <c-x> :call ToggleComment()<cr>
xnoremap <c-x> :call ToggleComment()<cr>

" Text manipulation
nnoremap cu maviwu`a
nnoremap cU maviwU`a
inoremap <c-u> <Esc>gUiw`]a
inoremap <expr> <Tab> SmartTab()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
nnoremap <leader>p "0p
autocmd TerminalOpen * nnoremap <buffer> <leader>p :call term_sendkeys('', @0)<CR>i
autocmd TerminalOpen * nnoremap <buffer> p :call term_sendkeys('', @")<CR>i

" source/modify vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Open file browser
nnoremap <leader>l :Lexplore<cr>

" Manage windows
nnoremap <leader><leader>w :w<cr>
nnoremap <leader><leader>q :q<cr>
nnoremap <leader>w f_
nnoremap <leader>b F_
inoremap <c-h> <esc><c-w>h
inoremap <c-j> <esc><c-w>j
inoremap <c-k> <esc><c-w>k
inoremap <c-l> <esc><c-w>l

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

tnoremap <c-h> <c-w>h
tnoremap <c-j> <c-w>j
tnoremap <c-k> <c-w>k
tnoremap <c-l> <c-w>l

nnoremap <leader>j 10j
nnoremap <leader>k 10k

nnoremap <Up> :resize +2<cr>
nnoremap <Down> :resize -2<cr>
nnoremap <Right> :vertical resize +2<cr>
nnoremap <Left> :vertical resize -2<cr>

" Terminal window
nnoremap <silent> <c-t> :call ToggleTerminal()<CR>
tnoremap <silent> <c-t> <C-w>N:call ToggleTerminal()<CR>
tnoremap <c-n> <c-w>N

" Git
nnoremap <leader>hp :call ToggleHunkPreview()<cr>
nnoremap <leader>hn :GitGutterNextHunk<cr>
nnoremap <leader>hN :GitGutterPrevHunk<cr>
nnoremap <leader>ha :GitGutterStageHunk<cr>

" To binary
noremap <c-b> :%!xxd <cr>

" LSP
nnoremap gd <plug>(lsp-definition)
nnoremap gr <plug>(lsp-references)
autocmd FileType qf nnoremap <buffer> gf :call QfOpenInSplit()<CR>
autocmd TerminalOpen * nnoremap <buffer> gf :call TermOpenFile()<CR>


function! PythonRgRefs() abort
    let l:word = expand('<cword>')
    let l:cmd = "rg --vimgrep --smart-case -g '*.py' -w -- " . shellescape(l:word) . " ."
    let l:lines = systemlist(l:cmd)
    call setqflist([], 'r', {'lines': l:lines, 'efm': '%f:%l:%c:%m'})
    botright cwindow
endfunction

augroup python_rg_refs
    autocmd!
    autocmd FileType python nnoremap <buffer> gr :call PythonRgRefs()<CR>
augroup END
"---- mapping end ----

let s:clang_list = ["c","cpp","m","mm","h","hh","hpp","ino"]
let s:prettier_list = ["css","html","json","js","ts"]

function! ToggleComment()
    let l:extension = expand('%:e')
    let s:pattern = ''
    if index(s:clang_list, l:extension) >= 0
        let s:pattern = '\/\/'
    elseif l:extension == "rs"
        let s:pattern = '\/\/'
    elseif l:extension == "zig"
        let s:pattern = '\/\/'
    elseif l:extension == "sh"
        let s:pattern = "#"
    elseif l:extension == "py"
        let s:pattern = "#"
    elseif l:extension == "js"
        let s:pattern = '\/\/'
    elseif l:extension == "ts"
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
        silent! w | w !clang-format > %
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
        redraw!
    elseif l:extension == "py"
        silent! w | w !python3 -m autopep8 --in-place --aggressive --aggressive --max-line-length 100 %
    elseif l:extension == "rs"
        w | w !rustfmt %
    elseif l:extension == "zig"
        w | w !zig fmt %
    elseif l:extension == "swift"
        w | w !swift-format - > %
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
    :execute 'rg --vimgrep /\<'.s:wordUnderCursor.'\>/g `fd -H --ignore-file .gitignore -E ".git"`'
    " Open the navigation window.
    :copen
    " Move cursor to the window in which the search was launched.
    :execute "norm! \<C-W>p"
endfunction

function! SmartTab() abort
    " 1. If menu is open, scroll down
    if pumvisible()
        return "\<C-n>"
    endif

    " 2. If at a space or start of line, insert a real Tab
    let col = col('.') - 1
    if !col || getline('.')[col - 1] =~# '\s'
        return "\<Tab>"
    endif

    " 3. If inside a comment or string, force Vim's native buffer completion
    let l:syn_group = synIDattr(synID(line('.'), col('.') - 1, 1), 'name')
    if l:syn_group =~? 'comment' || l:syn_group =~? 'string'
        return "\<C-n>"
    endif

    " 4. Otherwise, request code completion from the LSP (Omni-completion)
    if &omnifunc != ''
        return "\<C-x>\<C-o>"
    else
        return "\<C-n>"
    endif
endfunction

" Map the keys
inoremap <expr> <Tab> SmartTab()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

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

function! QfOpenInSplit()
  let l:idx = line('.') - 1
  let l:qf_entry = getqflist()[l:idx]
  wincmd p
  split
  execute 'buffer' l:qf_entry.bufnr
  call cursor(l:qf_entry.lnum, l:qf_entry.col)
endfunction

function! TermOpenFile()
    let l:file = expand('<cfile>')
    wincmd p
    split
    execute 'edit ' . l:file
endfunction
