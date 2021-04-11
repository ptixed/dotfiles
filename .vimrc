
" ------------------
" Pawel Krogulec
" ------------------

syntax on
filetype plugin indent on

fixdel

set listchars=tab:▸\ ,eol:¬

set number
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=2
set clipboard=unnamed,unnamedplus
set smartcase
set incsearch
set mouse=a
set laststatus=0
set timeoutlen=200 ttimeoutlen=200
set noswapfile
set hidden

" ------------------

" F8 buffer switching
nnoremap <F8> :bnext<cr>
inoremap <F8> <esc>:bnext<cr>a

" F3 find next
nnoremap <F3> n

" Ctrl-S save
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>a

" do not pollute the default register
nnoremap x "_x
vnoremap x "_x
nnoremap <del> "_x   
vnoremap <del> "_x

" insert mode on enter
nnoremap <cr> A<cr>

" Ctrl-D bash
noremap <c-d> :sh<cr>

" Ctrl-Z undo, Ctrl-R redo
inoremap <c-z> <esc>ui
nnoremap <c-z> u

" Ctrl-W close tab
nnoremap <c-w> :tabc<cr>
inoremap <c-w> <esc>:tabc<cr>i

" Ctrl-N new tab
nnoremap <c-n> :tabe<cr>
inoremap <c-n> <esc>:tabe<cr>i

" Ctrl-Q previous tab, Ctrl-E next tab
nnoremap <c-e> :tabp<cr>
inoremap <c-e> <esc>:tabp<cr>i
nnoremap <c-q> :tabp<cr>
inoremap <c-q> <esc>:tabp<cr>i

" ------------------
" changes colors based on mode

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

