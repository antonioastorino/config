" Resource:
" https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot
" https://stackoverflow.com/questions/45502128/vim-spell-highlighting
set nocompatible

so ~/config/mapping.vim
so ~/config/settings.vim

autocmd BufNewFile,BufRead *.ino setlocal tabstop=2 shiftwidth=2 softtabstop=2

function! MakeTags()
    silent !ctags -R .
    :redraw!
endfunction

function! Comment()
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

