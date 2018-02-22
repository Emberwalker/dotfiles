" vim: expandtab fdm=marker ts=2 sts=2 sw=2 fdl=0

"
" Neovim Plugin Install/Config
" Arkan <arkan@drakon.io>
"
" Do NOT make host-specific changes here! See dotfiles_local for host-specific configuration.
"

call EnsureExists('~/.local/share/nvim/plugged')
call plug#begin('~/.local/share/nvim/plugged')

" try load local plugin config
if filereadable(expand("~/.nvimplugs")) | source ~/.nvimplugs | endif

" load settings
if exists('g:plugin_groups')
  " overridden locally
  let s:plugin_groups = g:plugin_groups
else
  " defaults
  let s:plugin_groups = []
  " basics
  call add(s:plugin_groups, 'autocomplete')
  " JVM
  "call add(s:plugin_groups, 'java')
  "call add(s:plugin_groups, 'scala')
  "call add(s:plugin_groups, 'kotlin')
  " Dynamics
  "call add(s:plugin_groups, 'python')
  "call add(s:plugin_groups, 'ruby')
  "call add(s:plugin_groups, 'javascript')
  "call add(s:plugin_groups, 'typescript')
  " System languages
  call add(s:plugin_groups, 'c')
  call add(s:plugin_groups, 'c++')
  "call add(s:plugin_groups, 'go')
  "call add(s:plugin_groups, 'rust')
  " Functional
  "call add(s:plugin_groups, 'haskell')
  "call add(s:plugin_groups, 'erlang')
  "call add(s:plugin_groups, 'elixir')
  " documentation
  call add(s:plugin_groups, 'markdown')
  "call add(s:plugin_groups, 'restructured_text')
endif

" are any JVM plugins enabled?
let s:jvm_plugins = count(s:plugin_groups, 'java') ||
      \count(s:plugin_groups, 'scala') ||
      \count(s:plugin_groups, 'kotlin')

" essentials {{{
Plug 'vim-airline/vim-airline' "{{{
  let g:airline_theme = 'murmur'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '¦'
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  "}}}
Plug 'vim-airline/vim-airline-themes'
Plug 'neomake/neomake' "{{{
  autocmd! BufWritePost * Neomake
  "}}}
Plug 'nathanaelkane/vim-indent-guides' "{{{
  let g:indent_guides_start_level=1
  let g:indent_guides_guide_size=1
  let g:indent_guides_enable_on_vim_startup=1
  let g:indent_guides_color_change_percent=3
  let g:indent_guides_auto_colors=0
  function! s:indent_set_console_colors()
    hi IndentGuidesOdd ctermbg=235
    hi IndentGuidesEven ctermbg=236
  endfunction
  autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
  "}}}
Plug 'majutsushi/tagbar' "{{{
  nnoremap <silent> <F9> :TagbarToggle<CR>
  nnoremap <leader>t :TagbarToggle<CR>
  let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
    \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }
  "}}}
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'kshenoy/vim-signature'
Plug 'ryanoasis/vim-devicons'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-fugitive'   " git support
Plug 'tpope/vim-rhubarb'    " GitHub integration for fugitive
Plug 'tpope/vim-eunuch'     " UNIX utils
Plug 'tpope/vim-surround'   " (Un)surround bits of text
Plug 'tpope/vim-commentary' " (Un)comment lines
Plug 'ctrlpvim/ctrlp.vim'   " fuzzy finder {{{
  if executable('ag')
    " https://robots.thoughtbot.com/faster-grepping-in-vim
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
  else
    echom("ag is not installed; CtrlP and grep may be slower.")
  endif
  "}}}
Plug 'junegunn/vim-emoji'   " emoji support
Plug 'kien/rainbow_parentheses.vim'   " identify scopes by parens colours
"}}}

" colorschemes {{{
Plug 'altercation/vim-colors-solarized' "{{{
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
  "}}}
"Plug 'rakr/vim-two-firewatch'
"Plug 'duythinht/inori'
"Plug 'glortho/feral-vim'
Plug 'DrSpatula/vim-buddy'
"Plug 'trevorrjohn/vim-obsidian'
"Plug 'nanotech/jellybeans.vim'
"Plug 'sjl/badwolf'
"Plug 'jordwalke/flatlandia'
"}}}

" Tooling Sections
if count(s:plugin_groups, 'autocomplete') "{{{
  if has('python3')
    let s:deoplete = 1
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "{{{
      " based on https://www.gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim/
      let g:deoplete#enable_at_startup = 1
      if !exists('g:deoplete#omni#input_patterns')
        let g:deoplete#omni#input_patterns = {}
      endif
      autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
      inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    "}}}
    Plug 'Shougo/neco-vim' " vimscript completion for deoplete
    Plug 'Shougo/neoinclude.vim' " include completion
  else
    let s:deoplete = 0
    echom("Python 3 isn't available; disabling deoplete! Fix with 'pip3 install neovim'")
  endif
endif "}}}

" JVM Sections
if s:jvm_plugins "{{{
  Plug 'tfnico/vim-gradle'
endif "}}}

if count(s:plugin_groups, 'java') "{{{
  " TODO
endif "}}}

if count(s:plugin_groups, 'scala') "{{{
  " TODO
endif "}}}

if count(s:plugin_groups, 'kotlin') "{{{
  Plug 'udalov/kotlin-vim'
endif "}}}

" Dynamic Language Sections
if count(s:plugin_groups, 'python') "{{{
  if s:deoplete
    Plug 'zchee/deoplete-jedi'
  endif
endif "}}}

if count(s:plugin_groups, 'ruby') "{{{
  if s:deoplete
    Plug 'fishbullet/deoplete-ruby'
  endif
endif "}}}

if count(s:plugin_groups, 'javascript') "{{{
  " TODO
endif "}}}

if count(s:plugin_groups, 'typescript') "{{{
  " TODO
endif "}}}

" System Language Sections
if count(s:plugin_groups, 'c') "{{{
  Plug 'vim-scripts/a.vim'  " alternate.vim
  if s:deoplete && executable('clang')
    Plug 'Rip-Rip/clang_complete'
  elseif s:deoplete
    echom("clang isn't available. Install it with your package manager or brew to enable C completion.")
  endif
endif "}}}

if count(s:plugin_groups, 'c++') "{{{
  if !count(s:plugin_groups, 'c')
    echom("C plugins aren't enabled, but C++ plugins are! Fix your local nvimplugs configuration.")
  endif
endif "}}}

if count(s:plugin_groups, 'go') "{{{
  if s:deoplete && executable('gocode')
    Plug 'zchee/deoplete-go', { 'do': 'make'}
  elseif s:deoplete
    echom("gocode isn't available. Install with 'go get -u github.com/nsf/gocode' to enable Go completion.")
  endif
endif "}}}

if count(s:plugin_groups, 'rust') "{{{
  Plug 'rust-lang/rust.vim' "{{{
    if executable('rustfmt')
      let g:rustfmt_autosave = 1
    else
      echom("rustfmt isn't available. Install with 'cargo install rustfmt' to enable format on save for Rust files")
    endif
  "}}}
  if s:deoplete && executable('racer') && !empty('$RUST_SRC_PATH')
    Plug 'racer-rust/vim-racer'
  elseif s:deoplete && executable('racer')
    echom("RUST_SRC_PATH isn't set. Provide a valid rust-lang/rust/src path in your shell (see dotfiles)")
  elseif s:deoplete
    echom("racer isn't available. Install with 'cargo install racer' to enable Rust completion.")
  endif
endif "}}}

" Functional Language Sections
if count(s:plugin_groups, 'haskell') "{{{
  if s:deoplete && executable('ghc-mod')
    Plug 'eagletmt/neco-ghc'
  elseif s:deoplete
    echom("ghc-mod isn't available. Install it using cabal/stack.")
  endif
endif "}}}

if count(s:plugin_groups, 'erlang') "{{{
  Plug 'vim-erlang/vim-erlang-runtime'
  Plug 'vim-erlang/vim-erlang-compiler'
  Plug 'vim-erlang/vim-erlang-omnicomplete'
  Plug 'vim-erlang/vim-erlang-tags'
endif "}}}

if count(s:plugin_groups, 'elixir') "{{{
  Plug 'elixir-lang/vim-elixir'
  Plug 'slashmili/alchemist.vim'
endif "}}}

" Documentation Sections
if count(s:plugin_groups, 'markdown') "{{{
  " TODO
endif "}}}

if count(s:plugin_groups, 'restructured_text') "{{{
  " TODO
endif "}}}

" fin
call plug#end()
