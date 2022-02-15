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
set softtabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set autoread
set showmatch

autocmd BufNewFile,BufRead *.ino,*.sh setlocal tabstop=2 shiftwidth=2 softtabstop=2

let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
command! Tags execute ":call MakeTags()"
function! MakeTags()
    silent !ctags -R .
    :redraw!
endfunction

" Netrw configuration
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide = '^\./$,^\.\./$'
let g:netrw_winsize = 30

" Formatters
" Not sure how to set up autocmd to make it :retab and not overwite when shfmt
" fails. Therefore, I'm using 'Ï' instead.
" autocmd BufRead,BufNewFile *.c,*.cpp,*.h,*.hh,*.hpp*.m,*.mm setlocal equalprg=clang-format
" autocmd BufRead,BufNewFile *.sh setlocal equalprg=shfmt
noremap  :call Format()<CR>
" Alt+X
noremap ≈ :call Comment("yes")<cr>
" Alt+Shift+X
noremap ˛ :call Comment("no")<cr>

let s:clang_list = [
    \"c",
    \"cpp",
    \"m",
    \"mm",
    \"h",
    \"hh",
    \"hpp",
    \"ino"
    \]

function! Comment(yes_no)
    let l:extension = expand('%:e')
    let s:pattern = ''
    if index(s:clang_list, l:extension) >= 0
        let s:pattern = '\/\/'
    elseif l:extension == "sh"
        let s:pattern = "#"
    endif
    if (s:pattern == '')
        :echo "File extension ".l:extension." not supported yet"
        return
    endif
    if (a:yes_no == "yes")
        let $curr_col = col('.')
        " Check if the line is already a comment.
        if (col('$') == 1) " this is an empty line - skip
            return
        endif
        " Remove comment if already present.
        :call Comment("no")
        " prepend the pattern
        :execute 's/^/' . s:pattern . '/'
        :call cursor(line('.'),$curr_col)
    else
        let $curr_col = col('.')
        try
            :execute 's/^\s*' . s:pattern . '//'
            " the following line is execute only if the pattern removal does
            " not fail
            :call cursor(line('.'),$curr_col)
        catch
            " do nothing
        endtry
    endif
endfunction

function! Format()
    let l:extension = expand('%:e')
    " Save the file, pass it to clang-format
    if index(s:clang_list, l:extension) >= 0
        if l:extension == "ino"
            let $format_style = "{IndentWidth: 2}"
        else
            let $format_style =
                \"{"
                \."BasedOnStyle: LLVM,"
                \."IndentWidth: 4,"
                \."DerivePointerAlignment: false,"
                \."PointerAlignment: Left,"
                \."AlignConsecutiveAssignments: true,"
                \."BinPackArguments: false,"
                \."BinPackParameters: false,"
                \."ExperimentalAutoDetectBinPacking: false,"
                \."AllowAllParametersOfDeclarationOnNextLine: false,"
                \."AllowShortIfStatementsOnASingleLine: false,"
                \."AllowShortBlocksOnASingleLine: false,"
                \."AllowShortLoopsOnASingleLine: false,"
                \."ColumnLimit: 100,"
                \."AccessModifierOffset: -4,"
                \."ConstructorInitializerAllOnOneLineOrOnePerLine: true,"
                \."BreakBeforeBinaryOperators: All,"
                \."BreakBeforeBraces: Allman,"
                \."UseTab: Never"
                \."}"
        endif
        silent! w | w !clang-format --style=$format_style > %
    elseif l:extension == "sh"
        w | w !shfmt -i 4 > fmttmp.tmp
        if (v:shell_error)
            !echo "Failed to format shell script."
        else
            silent !cat fmttmp.tmp > %
            :retab
        endif
        silent !rm fmttmp.tmp
        :redraw!
    elseif l:extension == "rs"
        w | w !rustfmt %
    endif
endfunction
" Format on save
autocmd BufWritePost * call Format()
