#!/bin/sh

# update all packages.
sudo apt update && sudo apt upgrade

# install packages.
sudo apt install -y lsd curl neovim bat

# tune the .basrhrc file.
echo "alias ls='lsd'" >> ~/.bashrc
echo "alias cat='batcat'" >> ~/.bashrc
