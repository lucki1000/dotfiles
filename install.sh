#!/bin/bash
#OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#Install Powerline 10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#Install Zsh Syntax Highlighting
cd ~
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#Install Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#Load my .zshrc
wget -O ~/.zshrc https://raw.githubusercontent.com/lucki1000/dotfiles/main/_zshrc
#Depencies you must yourself install
echo "Install:\nNeofetch"

