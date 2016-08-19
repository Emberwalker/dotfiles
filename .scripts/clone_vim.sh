#!/bin/bash

if [[ ! -d ~/.vim ]]; then
  git clone --recursive https://github.com/Emberwalker/dotvim.git ~/.vim
fi
