set nocompatible
syntax on

set background=light
set gfn=Monaco:h12

set autoindent
set cindent

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
"set smartindent

set hlsearch
set incsearch

set showmatch
set ignorecase
set smartcase

set number
set ruler

filetype on
filetype plugin on

nnoremap <F4> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1
"let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1

autocmd FileType python set omnifunc=pythoncomplete#Complete
inoremap <C-space> <C-x><C-o>

"--------------------------------------------------
" TAB smart completion s noignorecase
"--------------------------------------------------
"FIXME: predpoklad, ze chci jinde pouzivat ic
"TODO: use :normal i^P to call the default completion function
function! InsertTabCompl()
    setlocal noic
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
function! SetAfterCompl()
    setlocal ic
    return ""
endfunction
inoremap <tab> <c-r>=InsertTabCompl()<cr><c-r>=SetAfterCompl()<cr>

inoremap <F3> <c-p><c-r>=SetAfterCompl()<cr>
"-------------------------------------------------

set pastetoggle=<F2>
autocmd BufWritePre * :%s/\s\+$//e

nnoremap <F8> :!ctags -R --python-kinds=i --languages=+python .<CR>

let NERDTreeIgnore = ['\.pyc$']
nnoremap <F3> :NERDTreeTabsToggle<CR>

" `gf` jumps to the filename under the cursor.  Point at an import statement
" " and jump to it!
if !has('python')
    finish
endif

python << EOF
import vim
import sys
import os
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
