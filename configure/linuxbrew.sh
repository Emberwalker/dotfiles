#!/bin/sh
#
# Basic packages I tend to need from Homebrew/Linuxbrew
# Includes CMake, Git (with PCRE), Google Go, Gradle and Ninja
#

brew install -v cmake go gradle ninja
brew install -v git --with-pcre --with-gettext
