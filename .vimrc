set nocompatible
syntax on

set background=light
set gfn=Monaco:h12

set autoindent
set nocindent

set tabstop=4
set shiftwidth=4

set expandtab
set softtabstop=4

set smartindent

" tab rule for html/css/js files
autocmd FileType html,css,js setlocal tabstop=2 shiftwidth=2 softtabstop=2

" highlight all matches"
set hlsearch

" search as you type
set incsearch

set showmatch
set ignorecase
set smartcase

set number
set ruler

" Store swap files in fixed location, not current directory.
set dir=~/.vim/swap//

filetype on
filetype plugin on

let mapleader=","

nnoremap <leader>c :NERDTreeTabsToggle<CR>
nnoremap <leader>v :TlistToggle<CR>

let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1

"autocmd FileType python set omnifunc=pythoncomplete#Complete

"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  elseif strpart( getline('.'), col('.')-3, 2) == '</'
    return "\<C-X>\<C-O>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>


" pasting from clipboard in insertmode
set pastetoggle=<F2>

" trim spaces when saving
"autocmd BufWritePre * :%s/\s\+$//e

nnoremap <F8> :!ctags -R --python-kinds=-i --languages=+python .<CR>
set tags+=$PYTHONPATH_TAGS

nnoremap <F7> :!pycscope -R `pwd`<CR>

" add cscope.out in pythonpath, generated by function pycscope-pythonpath in ~/.bash_profile"
" source ~/.vim/plugin/cscope-pythonpath.vim

" search cscope.out recursively until found
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

inoremap <D-r> <Esc>:w\|:!python %<CR>
nnoremap <D-r> <Esc>:w\|:!python %<CR>

" easy escaping
inoremap jk <Esc>l
inoremap kj <Esc>l

nmap <D-1> <Esc>:tabp<CR>
imap <D-1> <Esc>:tabp<CR>
nmap <D-2> <Esc>:tabn<CR>
imap <D-2> <Esc>:tabn<CR>

nnoremap <C-h> <Esc><C-w>h<CR>
nnoremap <C-j> <Esc><C-w>j<CR>
nnoremap <C-k> <Esc><C-w>k<CR>
nnoremap <C-l> <Esc><C-w>l<CR>

set foldmethod=indent
set foldlevelstart=99
noremap <space> za

noremap <leader>f :call ToggleFoldmethod()<cr>
fun! ToggleFoldmethod()
  if &foldmethod == 'indent'
    exe 'set foldmethod=marker'
  else
    exe 'set foldmethod=indent'
  endif
endfun

" colorscheme koehler
" colorscheme mayansmoke
colorscheme zenburn
" colorscheme default

nnoremap <leader>t i<Tab><esc>l
nnoremap <leader>T i<backspace><esc>l


nnoremap <leader>w       :w<cr>
nnoremap <leader>w!      :w!<cr>
inoremap <leader>w  <c-o>:w<cr>
inoremap <leader>w! <c-o>:w!<cr>

nnoremap <leader>q       :q<cr>
nnoremap <leader>q!      :q!<cr>
inoremap <leader>q  <c-o>:q<cr>
inoremap <leader>q! <c-o>:q!<cr>

nnoremap <leader>wq       :wq<cr>
nnoremap <leader>wq!      :wq!<cr>
inoremap <leader>wq  <c-o>:wq<cr>
inoremap <leader>wq! <c-o>:wq!<cr>


nnoremap <leader>e i<enter><esc>k<CR>
nnoremap <leader>E i<backspace><esc>l

" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Open duplicate tab
nnoremap <silent><Leader><C-w>s <C-w>s<C-w>T<CR>

" Open ctags in new tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T<CR>

" bash like tab completion when opening file from vim
set wildmode=longest,list,full
set wildmenu

"Rename tabs to show tab# and # of viewports
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i
            if tabpagewinnr(i,'$') > 1
                let s .= '.'
                let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
                let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
            end

            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= file
            let s .= (i == t ? '%m' : '')
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

set tabpagemax=15
hi TabLineSel term=bold cterm=bold ctermfg=16 ctermbg=229
hi TabWinNumSel term=bold cterm=bold ctermfg=90 ctermbg=229
hi TabNumSel term=bold cterm=bold ctermfg=16 ctermbg=229

hi TabLine term=underline ctermfg=16 ctermbg=145
hi TabWinNum term=bold cterm=bold ctermfg=90 ctermbg=145
hi TabNum term=bold cterm=bold ctermfg=16 ctermbg=145

" show fugitive git status
set statusline=
set statusline+=%{fugitive#statusline()}    "git branch
set statusline+=\ %m                        "modified flag
set statusline+=\ %F                        "full path
set statusline+=%=%l,%v                     "current line,column number
set statusline+=\ %P\ of\ %L                "percent through file of total lines"


" based on:
"    http://vim.1045645.n5.nabble.com/editing-Python-files-how-to-keep-track-of-class-membership-td1189290.html

function! s:get_last_python_class()
    let l:retval = ""
    let l:last_line_declaring_a_class = search('^\s*class', 'bnW')
    let l:last_line_starting_with_a_word_other_than_class = search('^\ \(\<\)\@=\(class\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_class < l:last_line_declaring_a_class
        let l:nameline = getline(l:last_line_declaring_a_class)
        let l:classend = matchend(l:nameline, '\s*class\s\+')
        let l:classnameend = matchend(l:nameline, '\s*class\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:classend, l:classnameend-l:classend)
    endif
    return l:retval
endfunction

function! s:get_last_python_def()
    let l:retval = ""
    let l:last_line_declaring_a_def = search('^\s*def', 'bnW')
    let l:last_line_starting_with_a_word_other_than_def = search('^\ \(\<\)\@=\(def\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_def < l:last_line_declaring_a_def
        let l:nameline = getline(l:last_line_declaring_a_def)
        let l:defend = matchend(l:nameline, '\s*def\s\+')
        let l:defnameend = matchend(l:nameline, '\s*def\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:defend, l:defnameend-l:defend)
    endif
    return l:retval
endfunction

function! s:compose_python_location()
    let l:pyloc = s:get_last_python_class()
    if !empty(pyloc)
        let pyloc = pyloc . "."
    endif
    let pyloc = pyloc . s:get_last_python_def()
    return pyloc
endfunction

function! <SID>EchoPythonLocation()
    echo s:compose_python_location()
endfunction

command! PythonLocation :call <SID>EchoPythonLocation()
nnoremap <Leader>/ :PythonLocation<CR>

if !has('python')
    finish
endif

""" End for CLI vi"""

if has("gui_running")
    set guioptions=egmrt
endif

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
