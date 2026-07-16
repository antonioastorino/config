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
set t_vb=
set shell=zsh
set complete-=i
"
" fix hanging when opening .ts files
" (https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file)
autocmd BufNewFile,BufReadPre *.ts setlocal re=2
autocmd BufNewFile,BufRead *.html,*.js,*.ts,*.swift setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd TerminalOpen * set nonu nornu
autocmd FileType qf nnoremap <buffer> gf :call QfOpenInSplit()<CR>
autocmd TerminalOpen * nnoremap <buffer> gf :call TermOpenFile()<CR>
autocmd FileType c,cpp,python setlocal omnifunc=TagCompleteFunc

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
if has('patch-8.2.0953')
    set spelloptions=camel
endif
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

" --- ctags ---
set tags=./tags;,tags;
autocmd BufWritePost * if filereadable('.keep-tags') | call job_start([exepath('ctags.exe'), '-R', '.']) | endif
autocmd VimEnter * if filereadable('.keep-tags') | call job_start([exepath('ctags.exe'), '-R', '.']) | endif

nnoremap <silent> gd :execute 'tag ' . expand('<cword>')<cr>
nnoremap gr :call FindGlobal()<cr>

" MAPPING
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
inoremap <expr> <tab> Autocomplete()
nnoremap <leader>p "0p

" source/modify vimrc
nnoremap <leader>sv :so ~/config/.vimrc <cr>
nnoremap <leader>ev :vs ~/config/.vimrc <cr>

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

" SETTINGS
let s:clang_list = ["c","cpp","m","mm","h","hh","hpp","ino"]
let s:prettier_list = ["css","html","json","js","ts"]
let s:shell_list = ["sh","zsh"]

function! ToggleComment()
    let l:extension = expand('%:e')
    let s:pattern = ''
    if index(s:clang_list, l:extension) >= 0
        let s:pattern = '\/\/'
    elseif l:extension == "rs"
        let s:pattern = '\/\/'
    elseif l:extension == "zig"
        let s:pattern = '\/\/'
    elseif index(s:shell_list, l:extension) >= 0
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
    elseif index(s:shell_list, l:extension) >= 0
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
        silent! w | w !ruff format --line-length 200 --cache-dir /tmp/.ruff_cache %
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
    let l:ext_filter = ''
    if &filetype ==# 'python'
        let l:ext_filter = ' -t py'
    endif
    try
        let l:cmd = 'rg --vimgrep' . l:ext_filter . ' --smart-case -- "\<' . s:wordUnderCursor . '\>"'
        cexpr system(l:cmd)
        :botright copen
    catch
        echo "No matches found"
    endtry
endfunction

function! TagCompleteFunc(findstart, base)
    if a:findstart
        let l:col = col('.') - 1
        while l:col > 0 && getline('.')[l:col - 1] =~ '\k'
            let l:col -= 1
        endwhile
        return l:col
    else
        let l:tags = map(taglist('^' . a:base), 'v:val["name"]')
        let l:bufwords = filter(map(getline(1, '$')->copy(), {_, v -> matchstr(v, '\<' . a:base . '\k*')}), {_, v -> v != ''})
        return uniq(sort(l:tags + l:bufwords))
    endif
endfunction
autocmd FileType c,cpp,python setlocal omnifunc=TagCompleteFunc

function! Autocomplete()
    if pumvisible()
        return "\<C-n>"
    endif
    let l:col = col('.') - 1
    if l:col == 0 || getline('.')[l:col - 1] =~ '\s'
        return "\<Tab>"
    endif
    if &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'python'
        return "\<C-x>\<C-o>"
    endif
    return "\<Tab>"
endfunction

let s:term_buf_nr = -1
function! ToggleTerminal() abort
    if s:term_buf_nr == -1
        execute "terminal"
        wincmd L  " Safely moves the terminal window to the far right
        let s:term_buf_nr = bufnr("$")
    else
        try
            execute "bdelete! " . s:term_buf_nr
        catch
            let s:term_buf_nr = -1
            call ToggleTerminal()
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
