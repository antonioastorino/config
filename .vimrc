" Resource: https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot
set nocompatible
syntax enable
filetype plugin on
set path+=**
set wildmenu
set tags=tags

"
set autoindent
set number relativenumber
set nu rnu
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
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
command Tags execute ":call MakeTags()"
function! MakeTags()
    silent !ctags -R .
    :redraw!
endfunction

" Formatters
" Not sure how to set up autocmd to make it :retab and not overwite when shfmt
" fails. Therefore, I'm using 'Ï' instead.
" autocmd BufRead,BufNewFile *.c,*.cpp,*.h,*.hh,*.hpp*.m,*.mm setlocal equalprg=clang-format
" autocmd BufRead,BufNewFile *.sh setlocal equalprg=shfmt
noremap  :call Format()<CR>
function! Format()
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
    elseif extension == "sh"
        w | w !shfmt > fmttmp.tmp
        if (v:shell_error)
            !echo "Failed to format shell script."
        else
            silent !cat fmttmp.tmp > %
            :retab
        endif
        silent !rm fmttmp.tmp
        :redraw!
    elseif extension == "rs"
        w | w !rustfmt %
    endif
endfunction
" Format on save
autocmd BufWritePost <buffer> call Format()
