inoremap jk <esc>
inoremap <esc> <nop>
" After this, change split by using h/j/k/l 
nnoremap <leader>w <esc><c-w>

inoremap <c-f> <esc>:call Format()<cr>
nnoremap <c-f> :call Format()<cr>
inoremap <c-x> <esc>:call ToggleComment()<cr>
nnoremap <c-x> :call ToggleComment()<cr>

" source/modify vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Open file browser
nnoremap <leader>l :Lexplore<cr>

" Manage windows
nnoremap <leader><leader>w :w<cr>
nnoremap <leader><leader>q :q<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

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


