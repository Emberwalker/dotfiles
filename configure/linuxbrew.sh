#!/bin/sh
#
# Basic packages I tend to need from Homebrew/Linuxbrew
# Includes CMake, Git (with PCRE), Google Go, Gradle and Ninja
#

brew install -v cmake go gradle ninja

# Reinstall git if it's already in brew to adopt flags
if (brew list | grep git 2>&1 >/dev/null); then
  brew reinstall -v git --with-pcre --with-gettext
else
  brew install -v git --with-pcre --with-gettext
fi
