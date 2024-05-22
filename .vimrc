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
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set ignorecase
set smartcase
set incsearch
set laststatus=1
set timeoutlen=300 ttimeoutlen=300
set noswapfile
set hidden
set showcmd
set autoindent
set nofixendofline
set iskeyword+=-
set mouse=a
set shell=/usr/bin/fish
set titlestring=%t
set belloff=all

command Bd bn|bd

hi CursorLine cterm=none ctermbg=0
hi CursorLineNr cterm=none ctermbg=0

" ------------------

" jump to end of paste
nnoremap p gp

" mark pasted
nnoremap gp `[v`]

nnoremap <cr> o
nnoremap <space> a

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

inoremap <c-f> <esc>/
nnoremap <c-f> /

inoremap <c-r> <esc>:%s/<c-r><c-w>/
nnoremap <c-r> :%s/<c-r><c-w>/
vnoremap <c-r> :s/

vnoremap <BS> "_di

" ------------------
" changes colors based on mode

hi StatusLine ctermfg=3
hi StatusLineNC ctermfg=0
hi LineNr ctermfg=4
autocmd InsertEnter * exe "hi LineNr ctermfg=3"
autocmd InsertLeave * exe "hi LineNr ctermfg=4"

