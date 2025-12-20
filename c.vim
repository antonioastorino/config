" Better syntax highlighter for C"

sn match	cTypeDef	"\<\([a-z_0-9]*_t\)\>"
" -- syn match	cJCParamType	"\<\(\(const\|void\|restrict\|volatile\|signed\|unsigned\|struct\|enum\)[ \t*]\+\)*\I\i*[ \t*]\+\I"he=e-1 contained containedin=cJCFor
hi cTypeDef ctermfg=LightBlue     cterm=bold
hi cType ctermfg=LightBlue

