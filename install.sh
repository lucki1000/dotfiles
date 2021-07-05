#!/bin/bash
clear
echo ":: Starting installation of ZSH              ::"
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypper
osInfo[/etc/debian_version]=apt

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo ":: Package manager: ${osInfo[$f]}        ::"
        sys_installer=${osInfo[$f]}
    fi
done

install_deps () {
    echo ":: Install dependencies                      ::"
    if [[ sys_installer == "pacman" ]]
    then 
        sudo pacman -Sy curl git zsh neofetch fzf --noconfirm &>/dev/null
    elif [[ sys_installer == "apt" ]]
    then 
        sudo apt update && sudo apt install curl git zsh neofetch fzf -y &>/dev/null
    elif [[ sys_installer == "yum" ]]
    then
        sudo yum -y install curl zsh git neofetch fzf &>/dev/null
    elif [[ sys_installer == "zypper" ]]
    then
        sudo zypper --non-interactive in curl git zsh neofetch fzf &>/dev/null
    fi
    echo ":: Dependencies are installed                ::"
}

#Install dependencies
install_deps

#OhMyZsh
echo ":: Install OhMyZsh                           ::"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
#Install Powerline 10K
echo ":: Install Powerline 10K                     ::"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &>/dev/null
#Install Zsh Syntax Highlighting
echo ":: Install Zsh Syntax Highlighting           ::"
cd ~ 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git &>/dev/null
#Install Zsh Autosuggestions
echo ":: Install Zsh Autosuggest                   ::"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
#Load my .zshrc
echo ":: load .zshrc                               ::"
wget -O ~/.zshrc https://raw.githubusercontent.com/lucki1000/dotfiles/main/_zshrc &>/dev/null
#Set P10K theme
echo ":: load p10k settings                        ::"
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/lucki1000/dotfiles/main/_p10k.zsh &>/dev/null
echo ":: Finished                                  ::"
