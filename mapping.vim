let mapleader = " "

inoremap jk <esc>
inoremap <esc> <nop>
" After this, change split by using h/j/k/l 
nnoremap <leader>w <esc><c-w>
inoremap <c-f> <esc>:call Format()<cr>
nnoremap <c-f> :call Format()<cr>
noremap <c-x> :call ToggleComment()<cr>

" source/modify vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Open file brawser
nnoremap <leader>l :Lexplore<cr>

nnoremap <leader><leader>w :w<cr>
nnoremap <leader><leader>q :q<cr>
nnoremap <leader>wq :wq<cr>

" Git
nnoremap <leader>gd :call GitDiff()<cr>
nnoremap <leader>hp :call ToggleHunkPreview()<cr>

" Tags
nnoremap <leader><leader>t :call MakeTags()<cr>

