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
highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red
let g:gitgutter_enabled = 1

" Highlight
set cursorline
set cursorcolumn
highlight CursorLine   cterm=underline ctermbg=none
highlight CursorColumn cterm=NONE ctermbg=darkgray guibg=darkgray
highlight Visual       ctermbg=green ctermfg=white

" Enable spell checker - CamelCase is not a misspelled word
set spell spelllang=en_us
set spelloptions=camel
hi clear SpellBad
hi SpellBad cterm=underline
hi clear SpellRare
hi SpellRare cterm=underline
hi clear SpellCap
hi SpellCap cterm=underline
hi clear SpellLocal
hi SpellLocal cterm=underline
