
" ------------------
" Pawel Krogulec
" ------------------

" let g:GPGDebugLevel = 2
" let g:GPGDebugLog = expand('~/gnupg.log')

syntax on
filetype plugin indent on

fixdel
set whichwrap+=<,>,h,l,[,]

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
set cursorline
set mouse=a

command Bd bn|bd! #

hi CursorLine cterm=none ctermbg=0
hi CursorLineNr cterm=none ctermbg=0

" ------------------

" faster buffer switch
nnoremap bn :bn<cr>

" better backspace
nnoremap <bs> i<bs>

" section navigation
nnoremap ]] ]}
nnoremap [[ [{

" F3 find next
nnoremap <F3> n

" Ctrl-S save
nnoremap <c-s> :wa<cr>
inoremap <c-s> <esc>:wa<cr>a

" do not pollute the default register
nnoremap x "_x
vnoremap x "_x
nnoremap <del> "_x   
vnoremap <del> "_x

" do not overwrite register when pasting
vnoremap p "_dp

" insert mode on enter
nnoremap <cr> i<cr>

" Ctrl-D bash
inoremap <c-d> <esc>:w<cr>:sh<cr>
nnoremap <c-d> :w<cr>:sh<cr>

" Ctrl-Z undo, Ctrl-R redo
inoremap <c-z> <esc>ui
nnoremap <c-z> u

" Ctrl-N new tab
nnoremap <c-n> :tabe<cr>
inoremap <c-n> <esc>:tabe<cr>i

" Ctrl-Q previous tab, Ctrl-E next tab
nnoremap <c-e> :tabn<cr>
inoremap <c-e> <esc>:tabn<cr>i
nnoremap <c-q> :tabp<cr>
inoremap <c-q> <esc>:tabp<cr>i

inoremap <c-w>w <esc><c-w>Wi
nnoremap <c-w>w <c-w>W
inoremap <c-w><c-w> <esc><c-w><c-w>i

" ------------------
" changes colors based on mode

hi StatusLine ctermfg=3
hi StatusLineNC ctermfg=0
hi LineNr ctermfg=4
autocmd InsertEnter * exe "hi LineNr ctermfg=3"
autocmd InsertLeave * exe "hi LineNr ctermfg=4"

