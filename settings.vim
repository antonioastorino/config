syntax enable
filetype plugin on
set path+=**
set wildmenu
set tags=tags
set autoindent
set number relativenumber
set nu rnu
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set autoread
set showmatch

" GitGutter
set updatetime=100
let g:gitgutter_enabled = 1
highlight GitGutterAdd    ctermfg=Green
highlight GitGutterChange ctermfg=Yellow
highlight GitGutterDelete ctermfg=Red
highlight SignColumn      ctermbg=Black

" Cursor
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"
highlight CursorLine   cterm=underline ctermbg=none
highlight CursorColumn cterm=NONE ctermbg=darkgray guibg=darkgray
highlight Visual       ctermbg=green ctermfg=white
autocmd VimEnter    * setlocal cursorline
autocmd WinEnter    * setlocal cursorline
autocmd BufWinEnter * setlocal cursorline
autocmd WinLeave    * setlocal nocursorline
autocmd VimEnter    * setlocal cursorcolumn
autocmd WinEnter    * setlocal cursorcolumn
autocmd BufWinEnter * setlocal cursorcolumn
autocmd WinLeave    * setlocal nocursorcolumn

" Spell checker - CamelCase is not a misspelled word
set spell spelllang=en_us
set spelloptions=camel
highlight clear SpellBad
highlight SpellBad cterm=underline
highlight clear SpellRare
highlight SpellRare cterm=underline
highlight clear SpellCap
highlight SpellCap cterm=underline
highlight clear SpellLocal
highlight SpellLocal cterm=underline

" Netrw configuration
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide = '^\./$,^\.\./$'
let g:netrw_winsize = 30

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE

