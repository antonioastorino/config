set nocompatible
" Resource: https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot
syntax enable
filetype plugin on
set path+=**
set wildmenu
set tags=tags
"
set autoindent
set number relativenumber
set nu rnu
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set autoread
set showmatch
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
noremap <silent> Ï :call ClangFormat()<cr>
function! ClangFormat()
    " Save the file, pass it to clang-format
    let extension = expand('%:e')
    let clang_list = [
        \"c",
        \"cpp",
        \"m",
        \"mm",
        \"h",
        \"hh",
        \"hpp"
        \]
    if index(clang_list, extension) >= 0
        w | w !clang-format > %
    elseif extension == "rs"
        w | w !rustfmt %
    endif
endfunction
