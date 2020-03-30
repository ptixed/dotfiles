
" ------------------
" Pawel Krogulec
" ------------------

set number

syntax on
filetype plugin indent on

set tabstop=4
set shiftwidth=4
set expandtab
set backspace=2
set clipboard=unnamed,unnamedplus
set smartcase
set incsearch
set mouse=a

set laststatus=2 
set timeoutlen=200 ttimeoutlen=200
set noswapfile
set nofixendofline

" ------------------

nnoremap <F8> :bnext<cr>
inoremap <F8> <esc>:bnext<cr>a

" ------------------

nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>a

nnoremap x "_x
vnoremap x "_x

nnoremap <del> "_<del>   
vnoremap <del> "_<del>

nnoremap <enter> A<enter>
nnoremap p p`]

" ------------------

inoremap jj <esc>
noremap <c-d> :sh<cr>

