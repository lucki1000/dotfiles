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
    #vim +PluginInstall +qall
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
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &>/dev/null
wget -O ~/.vimrc https://raw.githubusercontent.com/lucki1000/dotfiles/main/vimrc &>/dev/null
#install Vim Plugins
echo -e "\e[31m::\e[0m Install Vim Plugins                       \e[31m::\e[0m"
setup_vim

printf "Do you want my hyprland config? ARCH ONLY\nyes\nno\n"
read  -r choice
if [[ $choice == "yes" ]]
then
    sudo pacman -S --needed git base-devel --noconfirm && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
    yay -Syu wlogout wofi we10x-icon-theme xcursor-arch-cursor-complete nerd-fonts-meta hyprland xdg-desktop-portal-hyprland sway swayidle wl-clipboard wireplumber slurp grim hyprpicker waybar-hyprland-git swaylock-effects qt5-wayland qt6-wayland polkit-kde-agent dunst copyq --noconfirm
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/hyprland.conf --create-dirs -o ~/.config/hypr/hyprland.conf
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/swayidle/config --create-dirs -o ~/.config/swayidle/config
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/swaylock/config --create-dirs -o ~/.config/swaylock/config
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/waybar/config --create-dirs -o ~/.config/waybar/config
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/waybar/style.css --create-dirs -o ~/.config/waybar/style.css
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/bin/grimblast --create-dirs -o ~/.bin/grimblast
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/wlogout/layout --create-dirs -o ~/.config/wlogout/layout
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/wlogout/style.css --create-dirs -o ~/.config/wlogout/style.css
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/wofi/config --create-dirs -o ~/.config/hypr/wofi/config
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/wofi/colors --create-dirs -o ~/.config/hypr/wofi/colors
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/wofi/style.css --create-dirs -o ~/.config/hypr/wofi/style.css
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/scripts/volume.sh --create-dirs -o ~/.config/hypr/scripts/volume.sh
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/hypr/scripts/wofi_menu.sh --create-dirs -o ~/.config/hypr/scripts/wofi_menu.sh
    curl https://raw.githubusercontent.com/lucki1000/dotfiles/main/config/dunst/dunstrc --create-dirs -o ~/.config/dunst/dunstrc
else 
    exit
fi	

echo -e "\e[31m::\e[0m Finished                                  \e[31m::\e[0m"