# Dotfiles
A repo made to simplify my new Linux installations.

## How to set up
Choose whatever you want to add to your system and `stow` it.

E.g: to `stow` my neovim config:
```sh
cd dotfiles/user
stow nvim
```

TLDR;
```sh
cd $HOME &&
git clone https://github.com/Diegovsky/dotfiles --recurse-submodules &&
cd dotfiles/user &&
stow *
```
