" 
" .vimrc
" Created by arkan@solaris.drakon.io
" Based on the vimrc files of KitB and neanias.
" 

" Vundle
set nocompatible     " be iMproved, required
filetype off         " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" GitHub plugins
Plugin 'tpope/vim-fugitive'                " Git support
Plugin 'tpope/vim-eunuch'                  " UNIX utils (SudoWrite/SudoEdit)
Plugin 'tpope/vim-sensible'                " Sensible defaults
Plugin 'majutsushi/tagbar'                 " Outline view
Plugin 'altercation/vim-colors-solarized'  " Purdy colours
Plugin 'bling/vim-airline'                 " AIRLINE!

" End of plugins
call vundle#end()            " required
filetype plugin indent on    " required

" COLOURS
syntax enable
set background=dark
colorscheme solarized

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='molokai'

" Autocmds
autocmd BufEnter *.md set ft=markdown

" Split window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Leader commands
map <Leader>t :TagbarToggle<CR>           " Tagbar
map <Leader>x :noh<CR>                    " Clear search highlights

" Set commands
set autoindent                            " Self-explanatory
set backspace=indent,eol,start            " Bksp behaviour
set backupdir=~/.vimbackup,.,/tmp         " Redirect backup files
set clipboard+=unnamed                    " Send yanks to clipboard
set cursorline                            " Highlight current line
set directory=~/.vimtmp,~/tmp,/tmp        " tmp dirs
set encoding=utf8                         " Default to UTF-8 encoding
set expandtab                             " Tab expansion?
set fileencoding=utf8                     " Moar UTF-8 is required
set helplang=en                           " English help, please
set hlsearch                              " Highlight all matches
set ignorecase                            " Ignore case in searches
set incsearch                             " Incremental search
set number                                " Line numbers
set relativenumber                        " Relative line numbering
set ruler                                 " Force showing bottom bar I think?
set scrolloff=5                           " Move page down with 5 line buffer
set showmatch                             " Show matching braces.
set showtabline=2                         " Always show tabline
set t_Co=256                              " 256 term colours
set termencoding=utf-8                    " UTF-8 term encoding
set undodir=~/.vimundo                    " Store undo files here
set undofile                              " Store undo in files
set wildmenu                              " Menu on statusbar for command autocomplete
set smartcase                             " Enable case sensitive searching when first char is capitalised

" Indent controls
set tabstop=4      " 4 column literal tabs
set expandtab      " Spaces, not tabs
set shiftwidth=2   " 2 space shifts
set softtabstop=4  " 4 space tabs
set smarttab       " Guess indentation from earlier part of line

" Death to the arrow keys! (Insert/Command mode)
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

