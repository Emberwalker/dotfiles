" 
" .vimrc
" Created by arkan@solaris.drakon.io
" Based on the vimrc files of KitB and neanias.
" 

" vim: set ts=8 sw=4 expandtab

" NeoBundle
set nocompatible     " be iMproved, required
filetype off         " required

" set the runtime path to include NeoBundle and initialize
set rtp+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))

" let NeoBundle manage itself; required
NeoBundleFetch 'Shougo/neobundle.vim'

" GitHub plugins
NeoBundle 'tpope/vim-fugitive'                 " Git support
NeoBundle 'tpope/vim-eunuch'                   " UNIX utils (SudoWrite/SudoEdit)
NeoBundle 'tpope/vim-sensible'                 " Sensible defaults
NeoBundle 'majutsushi/tagbar'                  " Outline view
NeoBundle 'bling/vim-airline'                  " AIRLINE!
NeoBundle 'scrooloose/syntastic'               " Syntax checking
NeoBundle 'Shougo/vimshell.vim'                " A shell, my kingdom for a shell!
NeoBundle 'Shougo/unite.vim'                   " All-rounder plugin. Not actually in any hero movies.
NeoBundle 'Shougo/vimfiler.vim'                " File explorer ('filer')


" Advanced plugins
" vimproc.vim: Allows some Vim plugins to go NYOOOEEEERM! (go faster by running background jobs)
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build' : {
            \     'windows' : 'tools\\update-dll-mingw',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'linux' : 'make',
            \     'unix' : 'gmake',
            \    },
            \ }
" YouCompleteMe: Autocompletion for C-family languages + others
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build' : {
            \   'mac' : 'python install.py --clang-completer --gocode-completer',
            \   'linux' : 'python install.py --clang-completer --gocode-completer',
            \   }
            \ }

" Colours, all the colours
NeoBundle 'altercation/vim-colors-solarized'   " The classic
NeoBundle 'jordwalke/flatlandia'               " Mostly intended for MacVim, might be good all round
NeoBundle 'CruizeMissile/Revolution.vim'       " Orange and rusty
NeoBundle 'duythinht/inori'                    " Lower contrast, orangey
NeoBundle 'xero/sourcerer.vim'                 " Muted, simple with orange highlights

" Wonky/non-GitHub plugins
"NeoBundle 'https://github.com/bitc/vim-hdevtools.git'  " Haskell hdevtools support

" End of plugins
call neobundle#end()
filetype plugin indent on    " required

" COLOURS
syntax enable
set background=dark
set guifont=Hack:h11

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

" Set/Let commands
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

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Indent controls
set tabstop=4      " 4 column literal tabs
set expandtab      " Spaces, not tabs
set shiftwidth=4   " 4 space shifts
set softtabstop=4  " 4 space tabs
set smarttab       " Guess indentation from earlier part of line

" AU shortcuts
" Haskell
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <F3> :!ghci %<CR>

" Death to the arrow keys! (Insert/Command mode)
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

" Fix vim behaviour in non-POSIX shells (i.e. fish) by forcing bash internally.
set shell=bash

" Bundle install reminder
NeoBundleCheck
