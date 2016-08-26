" vim: expandtab fdm=marker ts=2 sts=2 sw=2 fdl=0

"
" Global Neovim init file
" Arkan <arkan@drakon.io>
"
" Do NOT make host-specific changes here! See dotfiles_local for adding host-specific configuration.
" Large portions salvaged from old .vim (based on the bling config)
"

" functions
function! EnsureExists(path) "{{{
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction "}}}

" plugins
source ~/.config/nvim/plugins.vim

" base configuration {{{
set background=dark
silent! colorscheme buddy

set timeoutlen=700                                  "mapping timeout
set ttimeoutlen=50                                  "keycode timeout

set mouse=                                          "block mouse input
set mousehide                                       "hide when characters are typed
set history=1000                                    "number of command lines to remember
set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
set encoding=utf-8                                  "set encoding for text
if exists('$TMUX')
  set clipboard=
else
  set clipboard=unnamed                             "sync with OS clipboard
endif
set hidden                                          "allow buffer switching without saving
set autoread                                        "auto reload if file saved externally
set fileformats+=mac                                "add mac to auto-detection of file format line endings
set nrformats-=octal                                "always assume decimal numbers
set showcmd
set tags=tags;/
set showfulltag
set modeline
set modelines=5

if $SHELL =~ '/fish$'
  " VIM expects to be run from a POSIX shell.
  set shell=bash
endif

" line length marker
set colorcolumn=80
highlight ColorColumn ctermbg=235

" whitespace
set backspace=indent,eol,start                      "allow backspacing everything in insert mode
set autoindent                                      "automatically indent to match adjacent lines
set expandtab                                       "spaces instead of tabs
set smarttab                                        "use shiftwidth to enter tabs
let tabstop=2                                       "number of spaces per tab for display
let &softtabstop=2                                  "number of spaces per tab in insert mode
let &shiftwidth=2                                   "number of spaces when indenting
set list                                            "highlight whitespace
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set shiftround
set linebreak
let &showbreak='↪ '

set scrolloff=1                                     "always show content after scroll
set scrolljump=5                                    "minimum number of lines to scroll
set display+=lastline
set wildmenu                                        "show list for autocomplete
set wildmode=list:full
set wildignorecase

set splitbelow
set splitright

" disable sounds
set noerrorbells
set novisualbell
"}}}

" searching {{{
set hlsearch                                        "highlight searches
set incsearch                                       "incremental searching
set ignorecase                                      "ignore case for searching
set smartcase                                       "do case-sensitive if there's a capital letter
if executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif
if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
endif
"}}}

" vim file/folder management {{{
" persistent undo
if exists('+undofile')
  set undofile
  let &undodir = expand("~/.nvim/undo")
endif

" backups
set backup
let &backupdir = expand("~/.nvim/backup")

" swap files
let &directory = expand("~/.nvim/swap")
set noswapfile

call EnsureExists("~/.nvim")
call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)
"}}}

let mapleader = "\\"
let g:mapleader = "\\"

" ui configuration {{{
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set number
set relativenumber
set lazyredraw
set laststatus=2
set noshowmode
set foldenable                                      "enable folds by default
set foldmethod=syntax                               "fold via syntax of files
set foldlevelstart=99                               "open all folds by default
let g:xml_syntax_folding=1                          "enable xml folding

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline

if has('conceal')
  set conceallevel=1
  set listchars+=conceal:Δ
endif
"}}}

" keybindings {{{
" split switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" split resize
" height
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>= :exe "resize " . (winheight(0) * 2/3)<CR>
" width
nnoremap <silent> <Leader>[ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>] :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" toggle hlsearch with backspace
nnoremap <BS> :set hlsearch! hlsearch?<cr>

" tab shortcuts
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" buffer handling
nnoremap Q :bd<CR>

" smash escape
inoremap jk <esc>
inoremap kj <esc>

" change cursor position in insert mode
inoremap <C-h> <left>
inoremap <C-l> <right>

" search
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"}}}

" autocmds {{{
" restore last known location
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Rust style guide
autocmd FileType rust setlocal colorcolumn=100
autocmd FileType rust setlocal tabstop=4
autocmd FileType rust setlocal softtabstop=4
autocmd FileType rust setlocal shiftwidth=4
"}}}

" site config
if filereadable(expand("~/.nvimrc"))
  source ~/.nvimrc
endif
