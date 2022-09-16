
" ------------------
" Pawel Krogulec
" ------------------

" let g:GPGDebugLevel = 2
" let g:GPGDebugLog = expand('~/gnupg.log')

syntax on
filetype plugin indent on

fixdel

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

command Bd bn|bd! #

" ------------------

" faster buffer switch
nnoremap bn :bn<cr>

" better backspace
nnoremap <bs> i<bs>

" section navigation
nnoremap ]] ]}
nnoremap [[ [{

" faster navigation
nnoremap jk 10j
nnoremap kj 10k

" F8 buffer switching
nnoremap <F8> :bnext<cr>
inoremap <F8> <esc>:bnext<cr>a

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

inoremap <c-w><c-w> <esc><c-w><c-w>i

" ------------------
" changes colors based on mode

hi StatusLine ctermfg=3
hi StatusLineNC ctermfg=0
hi LineNr ctermfg=4
autocmd InsertEnter * exe "hi LineNr ctermfg=3"
autocmd InsertLeave * exe "hi LineNr ctermfg=4"

" ------------------
" autosave session by current directory

function! MakeSession()
    if (argc() != 0)
        return
    endif
    let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
    if (filewritable(b:sessiondir) != 2)
        exe 'silent !mkdir -p ' b:sessiondir
        redraw!
    endif
    let b:filename = b:sessiondir . '/session.vim'
    exe "mksession! " . b:filename
endfunction

function! LoadSession()
    if (argc() != 0)
        return
    endif
    let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
        exe 'source ' b:sessionfile
        echo "Session loaded."
    endif
endfunction

autocmd VimEnter * nested :call LoadSession()
autocmd VimLeave * :call MakeSession()
