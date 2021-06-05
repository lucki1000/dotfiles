#!/bin/bash

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypper
osInfo[/etc/debian_version]=apt

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo Package manager: ${osInfo[$f]}
        sys_installer=${osInfo[$f]}
    fi
done

install_deps () {
    if [[ sys_installer == "pacman" ]]
    then 
        sudo pacman -Sy curl git zsh neofetch fzf --noconfirm
    elif [[ sys_installer == "apt" ]]
    then 
        sudo apt update && sudo apt install curl git zsh neofetch fzf -y
    elif [[ sys_installer == "yum" ]]
    then
        sudo yum -y install curl zsh git neofetch fzf
    elif [[ sys_installer == "zypper" ]]
    then
        sudo zypper --non-interactive in curl git zsh neofetch fzf
    fi
}

#Install dependencies
install_deps

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
echo "Install:\nNeofetch\nfzf"
#Set P10K theme
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/lucki1000/dotfiles/main/_p10k.zsh