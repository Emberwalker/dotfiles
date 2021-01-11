" Disable vi compatibility mode
if &compatible
  set nocompatible
endif

" == neovim-sensible ==
" See https://github.com/jeffkreeftmeijer/neovim-sensible/blob/master/plugin/neovim-sensible.vim
set number relativenumber           " Use "hybrid" (both absolute and relative) line numbers
set clipboard=unnamed               " Use the system clipboard
set colorcolumn=120                 " Use a color column on the 120-character mark
let mapleader=" "                   " Use space as the leader key
nnoremap <leader><leader> :b#<CR>   " Use space-space to switch between buffers
set expandtab shiftwidth=2          " Press <tab>, get two spaces
set list listchars=tab:▸▸,trail:·   " Show `▸▸` for tabs: 	, `·` for tailing whitespace:
set mouse=a                         " Enable mouse mode


" == General (Before Plugins) ==
" Helper to make sure a directory exists
function! EnsureExists(path)
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction

set nomodeline        " modelines are an insecure feature
set ignorecase        " ignore case for searching
set smartcase         " do case-sensitive if there's a capital letter
set showmatch         " automatically highlight matching braces/brackets/etc.

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience. Needed by Signify/coc.nvim.
set updatetime=100

" open splits down and to the right
set splitbelow
set splitright

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

" Ctrl-{h,j,k,l} to navigate panes
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Ctrl-{Left,Down,Up,Right} to navigate panes
nnoremap <C-Right> <C-w>l
nnoremap <C-Left> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k

" Ctrl-{h,j,k,l} to move in insert mode
inoremap <C-l> <Right>
inoremap <C-h> <Left>
" These use g{j,k} to move down one visual line (incl. wraps)
inoremap <C-j> <C-o>gj
inoremap <C-k> <C-o>gk

" smash escape
inoremap jk <esc>
inoremap kj <esc>

" split resize
" height
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>= :exe "resize " . (winheight(0) * 2/3)<CR>
" width
nnoremap <silent> <Leader>[ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>] :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" toggle hlsearch with backspace
nnoremap <BS> :set hlsearch! hlsearch?<cr>

" toggle location list (Ale Diagnostics)
nnoremap <silent> <Leader>do :lopen<CR>
nnoremap <silent> <Leader>dc :lclose<CR>

" kill current buffer (wipeout) with bufkill
nnoremap <silent> Q :BW<CR>

" Which Key guide
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" Denite
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ` :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Ale diagnostics back/forward
nmap <silent> [d <Plug>(ale_previous_wrap)
nmap <silent> ]d <Plug>(ale_next_wrap)

" Toggle NERDTree
nnoremap <silent> <Leader>f :NERDTreeToggle<Enter>
" Open NERDTree on current file
nnoremap <silent> <Leader>v :NERDTreeFind<CR>

" Toggle TagBar (file structure)
nnoremap <leader>s :TagbarToggle<CR>

" coc go-to code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>rf  <Plug>(coc-format-selected)
nmap <leader>rf  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

if $SHELL =~ '/fish$'
  " VIM expects to be run from a POSIX shell.
  set shell=bash
endif

" restore last known location
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" trim trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e


" == Language Conventions ==
" Rust style guide
autocmd FileType rust setlocal colorcolumn=100
autocmd FileType rust setlocal tabstop=4
autocmd FileType rust setlocal softtabstop=4
autocmd FileType rust setlocal shiftwidth=4


" == Ale ==
" These must be set *before* Ale is loaded.
let g:ale_close_preview_on_insert = 1
let g:ale_disable_lsp = 1   " Defer to CoC.nvim for LSP interactions


" == Dein ==
set runtimepath+=~/.nvim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.nvim/dein')
  call dein#begin('~/.nvim/dein')

  " dein and it's UI
  call dein#add('~/.nvim/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  " essentials
  call dein#add('danilo-augusto/vim-afterglow')

  call dein#add('qpkorr/vim-bufkill')
  call dein#add('junegunn/rainbow_parentheses.vim')
  call dein#add('Yggdroot/indentLine')
  call dein#add('tpope/vim-sleuth')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('Shougo/denite.nvim')
  call dein#add('liuchengxu/vim-which-key')
  call dein#add('jeffkreeftmeijer/vim-numbertoggle')
  call dein#add('mhinz/vim-startify')

  call dein#add('preservim/tagbar')
  call dein#add('preservim/nerdtree')
  call dein#add('Xuyuanp/nerdtree-git-plugin')

  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('jremmen/vim-ripgrep')
  call dein#add('tpope/vim-eunuch')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('tpope/vim-commentary')

  call dein#add('tpope/vim-fugitive')
  call dein#add('mhinz/vim-signify')

  call dein#add('justinmk/vim-sneak')

  " Language support
  call dein#add('dense-analysis/ale')
  call dein#add('neoclide/coc.nvim', { 'merged': 0 })

  call dein#add('rust-lang/rust.vim')

  call dein#add('psf/black')
  call dein#add('numirias/semshi')

  " Syntaxes
  call dein#add('cespare/vim-toml')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install missing plugins
if dein#check_install()
  call dein#install()
endif


" == General (Post-Plugins) ==
let g:afterglow_inherit_background=1
colorscheme afterglow

syntax enable
filetype plugin indent on


" == RipGrep (:Rg) ==
" Use Smart Case (ignore case if all lower case)
let g:rg_command = 'rg --vimgrep -S'


" == Rainbow Parens ==
autocmd VimEnter * RainbowParentheses


" == Indent Guides ==
let g:indentLine_char_list = ['▏', '╵']
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['NERD_tree.*']


" == Denite ==
" FROM: https://www.freecodecamp.org/news/a-guide-to-modern-web-development-with-neo-vim-333f7efbf8e2/
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction


" == NERDTree ==
" Exit Vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

let g:NERDTreeAutoDeleteBuffer = 1    " Drop buffer if file is deleted
let g:NERDTreeMinimalUI = 1           " Hide help prompt
let g:NERDTreeDirArrows = 1           " Show directory arrows
let g:NERDTreeWinPos = "right"        " Show NERDTree on the right

let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1


" == Airline ==
let g:airline_powerline_fonts = 1
let g:airline_theme = "badwolf"
let g:airline#extensions#tabline#enabled = 1


" == Startify ==
let g:startify_fortune_use_unicode = 1  " Use pretty UTF-8 drawing symbols
let g:startify_banner_ascii = [
  \ '',
  \ '_____/\\\\\\\\\\\_________________________________________________________________________/\\\\\_______________',
  \ ' ___/\\\/////////\\\_____________________________________________________________________/\\\///________________',
  \ '  __\//\\\______\///______/\\\_______________________________________/\\\_______/\\\_____/\\\_________/\\\__/\\\_',
  \ '   ___\////\\\__________/\\\\\\\\\\\__/\\\\\\\\\_____/\\/\\\\\\\___/\\\\\\\\\\\_\///___/\\\\\\\\\_____\//\\\/\\\__',
  \ '    ______\////\\\______\////\\\////__\////////\\\___\/\\\/////\\\_\////\\\////___/\\\_\////\\\//_______\//\\\\\___',
  \ '     _________\////\\\______\/\\\________/\\\\\\\\\\__\/\\\___\///_____\/\\\______\/\\\____\/\\\__________\//\\\____',
  \ '      __/\\\______\//\\\_____\/\\\_/\\___/\\\/////\\\__\/\\\____________\/\\\_/\\__\/\\\____\/\\\_______/\\_/\\\_____',
  \ '       _\///\\\\\\\\\\\/______\//\\\\\___\//\\\\\\\\/\\_\/\\\____________\//\\\\\___\/\\\____\/\\\______\//\\\\/______',
  \ '        ___\///////////_________\/////_____\////////\//__\///______________\/////____\///_____\///________\////________',
  \ '' ]
let g:startify_custom_header = 'startify#pad(g:startify_banner_ascii + startify#fortune#boxed())'


" == CoC ==
set hidden        " TextEdit might fail if hidden is not set.
set cmdheight=2   " Give more space for displaying messages.
set shortmess+=c  " Don't pass messages to |ins-completion-menu|.

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif
set signcolumn=yes:1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OrganiseImports` command for organize imports of the current buffer.
command! -nargs=0 OrganiseImports :call CocAction('runCommand', 'editor.action.organizeImport')


" == Black ==
" Run on save
autocmd BufWritePre *.py execute ':Black'
