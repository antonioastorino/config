syntax on
set background=dark
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
set ruler
set showmatch
set splitbelow splitright
set scrolloff=5
set backspace=indent,eol,start
set hlsearch

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
highlight CursorColumn cterm=NONE ctermbg=236 guibg=darkgray
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
syntax spell toplevel
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
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE
highlight Search ctermfg=Grey ctermbg=DarkGrey

" Syntax highlight
let g:cpp_function_highlight = 1
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
let g:cpp_type_name_highlight = 1
let g:cpp_operator_highlight = 1
