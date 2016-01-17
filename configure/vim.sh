#!/bin/sh
# Vi IMproved
# Repo: https://github.com/vim/vim.git
#
# Requires packages listed on https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source + ruby, luajit and the libluajit files (the package name varies)

CC="clang" CXX="clang++" ./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-perlinterp --enable-luainterp --enable-gui=no --enable-cscope --prefix=/opt/vim --with-luajit --with-compiledby="Arkan <arkan@drakon.io>"
