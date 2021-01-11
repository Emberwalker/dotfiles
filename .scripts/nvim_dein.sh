#!/bin/bash

set -euxo pipefail

DEIN_PATH="$HOME/.nvim/dein/repos/github.com/Shougo/dein.vim"
if [ ! -d "$DEIN_PATH" ]; then
    mkdir -p "$DEIN_PATH"
    git clone https://github.com/Shougo/dein.vim "$DEIN_PATH"
fi
