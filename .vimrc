" vim is terrible but there is no better alternative

" let g:GPGDebugLevel = 2
" let g:GPGDebugLog = expand('~/gnupg.log')

syntax on
filetype plugin indent on
colorscheme default

fixdel
set whichwrap+=<,>,h,l,[,]
set viminfo+=n~/.vim/viminfo
set number
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set ignorecase
set smartcase
set incsearch
set laststatus=1
set timeoutlen=300 ttimeoutlen=0
set noswapfile
set hidden
set showcmd
set autoindent
set smartindent
set nofixendofline
set iskeyword+=-
set mouse=a
set shell=/usr/bin/fish
set titlestring=%t
set belloff=all
set foldmethod=syntax
set foldlevel=99
set wildmenu
set lazyredraw
set magic

let &t_SI = "\e[6 q"
let &t_EI = "\e[6 q"

command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

hi CursorLine cterm=none ctermbg=0
hi CursorLineNr cterm=none ctermbg=0

" ------------------

" mark pasted
nnoremap gp `[v`]

nnoremap p gP

" prevent cursor from sliding when changing modes
noremap <esc> <esc>l

" fold (see zM, zR)
noremap <2-LeftMouse> za

nnoremap <cr> i<cr>
nnoremap <space> i<space>

" faster buffer switch
nnoremap bn :bn<cr>

" better backspace
nnoremap <bs> i<bs>

" section navigation
nnoremap ]] ]}
nnoremap [[ [{

" Ctrl-S save
nnoremap <c-s> :wa<cr>
inoremap <c-s> <esc>:wa<cr>a

" do not pollute the default register
nnoremap x "_x
vnoremap x "_x
nnoremap <del> "_x   
vnoremap <del> "_x

" Ctrl-D bash
inoremap <c-d> <esc>:sh<cr>
nnoremap <c-d> :sh<cr>

" Ctrl-Z undo
inoremap <c-z> <esc>ua
nnoremap <c-z> u

" Ctrl-Y redo
inoremap <c-y> <esc><c-r>a
nnoremap <c-y> <c-r>

inoremap <c-a> <esc>ggVG

inoremap <c-c> <esc>yya
nnoremap <c-c> yy
vnoremap <c-c> y

inoremap <c-v> <esc>pa
nnoremap <c-v> p

inoremap <c-r> <esc>:%s/<c-r><c-w>/
nnoremap <c-r> :%s/<c-r><c-w>/
vnoremap <c-r> :s/

inoremap <c-n> <esc>:tabnew<cr>
nnoremap <c-n> :tabnew<cr>

inoremap <c-w> <esc>:tabnext<cr>
nnoremap <c-w> :tabnext<cr>

inoremap <c-q> <esc>:tabprevious<cr>
nnoremap <c-q> :tabprevious<cr>

vnoremap <BS> "_di

noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" ------------------
" changes colors based on mode

hi StatusLine ctermfg=3
hi StatusLineNC ctermfg=0
hi LineNr ctermfg=4
hi Folded ctermbg=0
autocmd InsertEnter * exe "hi LineNr ctermfg=3"
autocmd InsertLeave * exe "hi LineNr ctermfg=4"

