#!/bin/bash
clear
echo -e "\e[31m::\e[0m Starting installation of ZSH              \e[31m::\e[0m"
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypper
osInfo[/etc/debian_version]=apt

apt_packages="curl git zsh neofetch shellcheck fzf vim"
pacman_packages="curl git zsh neofetch fzf shellcheck duf vim"
yum_packages="curl zsh git neofetch ShellCheck fzf duf vim"
zypper_packages="curl git zsh ShellCheck neofetch fzf duf vim"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        #echo -e "\e[31m::\e[0m Package manager: ${osInfo[$f]}                ::"
        sys_installer=${osInfo[$f]}
    fi
done

install_deps () {
    if [[ $sys_installer == "pacman" ]]
    then 
        sudo pacman -Sy $pacman_packages --noconfirm
    elif [[ $sys_installer == "apt" ]]
    then 
        sudo apt update && sudo apt install $apt_packages -y
    elif [[ $sys_installer == "yum" ]]
    then
        sudo yum -y install $yum_packages
    elif [[ $sys_installer == "zypper" ]]
    then
        sudo zypper --non-interactive in $zypper_packages
    else
        exit
    fi
} > /dev/null 2>&1

setup_vim () {
    export vimver="$(ls /usr/share/vim/ |grep 'vim[0-9][0-9]')"
    sudo wget https://raw.githubusercontent.com/romainl/Apprentice/master/colors/apprentice.vim -O /usr/share/vim/"$vimver"/colors/apprentice.vim #Color Theme
    if [[ $sys_installer == "pacman" ]]
    then 
        echo "color apprentice" | sudo tee -a /etc/vimrc
    elif [[ $sys_installer == "apt" ]]
    then 
        echo "color apprentice" | sudo tee -a /etc/vim/vimrc
    fi
    vim +PluginInstall +qall
} > /dev/null 2>&1 

#Install dependencies
echo -e "\e[31m::\e[0m Install dependencies                      \e[31m::\e[0m"
install_deps
echo -e "\e[31m::\e[0m Dependencies are installed                \e[31m::\e[0m"

#Path to ZSH
#zshell_path="$(which zsh)"
#OhMyZsh
echo -e "\e[31m::\e[0m Install OhMyZsh                           \e[31m::\e[0m"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
#Install Powerline 10K
echo -e "\e[31m::\e[0m Install Powerline 10K                     \e[31m::\e[0m"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &>/dev/null
#Install Zsh Syntax Highlighting
echo -e "\e[31m::\e[0m Install Zsh Syntax Highlighting           \e[31m::\e[0m"
cd ~ 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git &>/dev/null
#Install Zsh Autosuggestions
echo -e "\e[31m::\e[0m Install Zsh Autosuggest                   \e[31m::\e[0m"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
#Load my .zshrc
echo -e "\e[31m::\e[0m load .zshrc                               \e[31m::\e[0m"
wget -O ~/.zshrc https://raw.githubusercontent.com/lucki1000/dotfiles/main/_zshrc &>/dev/null
#Set P10K theme
echo -e "\e[31m::\e[0m load p10k settings                        \e[31m::\e[0m"
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/lucki1000/dotfiles/main/_p10k.zsh &>/dev/null
echo -e "\e[31m::\e[0m Set ZSH as default SHELL                  \e[31m::\e[0m"
sed -i 's/lukas/$USER/g' .zshrc
sudo chsh -s $(which zsh) $USER
#Install Vundle
echo -e "\e[31m::\e[0m Install Vim and get Vim configuration     \e[31m::\e[0m"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &>/dev/null
wget -O ~/.vimrc https://raw.githubusercontent.com/lucki1000/dotfiles/main/vimrc &>/dev/null
#install Vim Plugins
echo -e "\e[31m::\e[0m Install Vim Plugins                       \e[31m::\e[0m"
setup_vim
echo -e "\e[31m::\e[0m Finished                                  \e[31m::\e[0m"