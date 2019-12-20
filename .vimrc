
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
set clipboard=unnamed
set smartcase
set incsearch
set mouse=a

set laststatus=2 
set timeoutlen=200 ttimeoutlen=200
set noswapfile

" ------------------

nnoremap <c-s> :w<CR>
inoremap <c-s> <Esc>:w<CR>a

nnoremap x "_x
vnoremap x "_x

nnoremap <del> "_<del>   
vnoremap <del> "_<del>

nnoremap <enter> A<enter>
nnoremap p p`]

" ------------------

inoremap jj <Esc>
noremap <C-d> :sh<cr>

