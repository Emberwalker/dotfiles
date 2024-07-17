# Dotfiles

Files which control stuff and things...

## Prerequisites
Install Nix using the [Determinate Systems nix-installer](https://github.com/DeterminateSystems/nix-installer).

## Installation
This repository is managed by [Dotbot](https://github.com/anishathalye/dotbot) - simply run `./install` in a clone.

To use nix-darwin management, `cd nix-darwin` and then:

```shell
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ".#base"
```

## Updating Included Packages
[  ] `curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > .antigen.zsh`
