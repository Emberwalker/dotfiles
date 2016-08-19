#!/bin/bash
#
# Install Homebrew/Linuxbrew
#

# fail on error
set -e

if [[ -d "$HOME/.linuxbrew" ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
fi

if hash brew 2>/dev/null; then
  echo ">> brew is already installed..."
  exit 0
fi

if ! hash ruby 2>/dev/null; then
  echo "!! No Ruby interpreter! Install the appropriate Ruby package for your OS."
  exit -1
fi

if ! hash curl 2>/dev/null; then
  echo "!! No cURL executable! Install the appropriate cURL package for your OS."
  exit -1
fi

if [[ "$OSTYPE" == "linux"*  ]]; then
  echo ">> Installing Linuxbrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
  export PATH="$HOME/.linuxbrew/bin:$PATH"
elif [[ "$OSTYPE" == "darwin"*  ]]; then
  echo ">> Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  export PATH="/usr/local/bin:$PATH"
else
  echo "!! Unknown OS: $OSTYPE - Cannot fetch a valid Homebrew install type."
  exit -2
fi
