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
let Tlist_File_Fold_Auto_Close = 1
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
"autocmd BufWritePre * :%s/\s\+$//e

nnoremap <F8> :!ctags -R --python-kinds=-i --languages=+python .<CR>
set tags+=$PYTHONPATH_TAGS

let NERDTreeIgnore = ['\.pyc$']
nnoremap <F3> :NERDTreeTabsToggle<CR>

inoremap <D-r> <Esc>:w\|:!python %<CR>
nnoremap <D-r> <Esc>:w\|:!python %<CR>

nmap <D-1> <Esc>:tabp<CR>
imap <D-1> <Esc>:tabp<CR>
nmap <D-2> <Esc>:tabn<CR>
imap <D-2> <Esc>:tabn<CR>

nnoremap <C-h> <Esc><C-w>h<CR>
nnoremap <C-j> <Esc><C-w>j<CR>
nnoremap <C-k> <Esc><C-w>k<CR>
nnoremap <C-l> <Esc><C-w>l<CR>

set foldmethod=indent
set foldnestmax=2
set foldlevelstart=99
nnoremap <space> za
vnoremap <space> zf

inoremap jk <Esc>

colorscheme koehler

let mapleader=","

" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

if has("gui_running")
    set guioptions=egmrt
endif

if !has('python')
    finish
endif

""" End for CLI vi"""

" change to the dir of current file
" this didn't work properly with nerdtreeplugin
"set autochdir

python << EOF
import vim
import sys
import os
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
