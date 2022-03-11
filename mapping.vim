inoremap jk <esc>
inoremap <esc> <nop>

" Code-specific
inoremap <c-f> <esc>:call Format()<cr>
nnoremap <c-f> :call Format()<cr>
inoremap <c-x> <esc>:call ToggleComment()<cr>
nnoremap <c-x> :call ToggleComment()<cr>

" Text manipulation
nnoremap cu maviwu`a
nnoremap cU maviwU`a
inoremap <c-u> <Esc>gUiw`]a
inoremap <expr> <tab> Autocomplete()

" source/modify vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Open file browser
nnoremap <leader>l :Lexplore<cr>

" Manage windows
nnoremap <leader><leader>w :w<cr>
nnoremap <leader><leader>q :q<cr>
nnoremap <leader>wq :wq<cr>
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

nnoremap <leader>j <PageDown>zz
nnoremap <leader>k <PageUp>zz

nnoremap <Up> :resize +2<cr>
nnoremap <Down> :resize -2<cr>
nnoremap <Right> :vertical resize +2<cr>
nnoremap <Left> :vertical resize -2<cr>

" Terminal window
nnoremap <silent> <c-t> :call ToggleTerminal()<CR>
tnoremap <silent> <c-t> <C-w>N:call ToggleTerminal()<CR>
tnoremap <c-n> <c-w>N

" Git
nnoremap <leader>gd :call GitDiff()<cr>
nnoremap <leader>hp :call ToggleHunkPreview()<cr>
nnoremap <leader>hn :GitGutterNextHunk<cr>
nnoremap <leader>hN :GitGutterPrevHunk<cr>

" Find
nnoremap <leader><leader>f :call FindGlobal()<cr>
nnoremap <leader>f :call FindLocal()<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>N :cprev<cr>
