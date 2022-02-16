let mapleader = " "

inoremap jk <esc>
inoremap <esc> <nop>
" After this, change split by using h/j/k/l 
nnoremap <leader>w <esc><c-w>
" Alt+F
inoremap ƒ <esc>:call Format()<cr>
nnoremap ƒ :call Format()<cr>
" Alt+X
noremap ≈ :call Comment()<cr>

" source/modify vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Open file brawser
nnoremap <leader>l :Lexplore<cr>

nnoremap <leader><leader>w :w<cr>
nnoremap <leader><leader>q :q<cr>
nnoremap <leader>wq :wq<cr>

