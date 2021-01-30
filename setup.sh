#!/bin/bash
#by Arsham Rezaei
#18/01/2021

# Variables

pkg_manager=""
pkg_option=""
pkg_confirm=""
pkg_list=""


# Creating the needed folder structure for -per user- configurations.
folder_structure () {
	mkdir /home/"$USER"/.fonts /home/"$USER"/.icons /home/"$USER"/.themes /home/"$USER"/temp
	chmod 777 /home/"$USER"/.fonts /home/"$USER"/.icons /home/"$USER"/.themes
	clear
}

# Setting the shell and icon theme in place
set_themes () {
	sudp "${pkg_manager}" "${pkg_option}" gnome-shell-extensions "${pkg_confirm}"
	unzip ./Files/themes.zip -d /home/"$USER"/.themes/
	unzip ./Files/icons.zip -d /home/"$USER"/.icons/
}

# Downloading Alacritty on Arch based systems using pacman.
set_terminal () {
  sudo "${pkg_manager}" "${pkg_option}" alacritty "$pkg_confirm"
	mkdir ~/.config/alacritty 
	cp dotconfig/alacritty.yml ~/.config/alacritty/
	chsh "$USER" -s /bin/zsh
	mkdir ~/.terminal
	
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
	/themes/powerlevel10k"

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
	/plugins/zsh-syntax-highlighting"

	cp ./.zshrc ~/
}

# Installing all the needed packages
install_packages(){
  for i in $(cat "$pkg_list") ; do sudo "${pkg_manager}" "${pkg_option}" "$i" "$pkg_confirm"; done
}

install_fonts(){
	unzip ./Files/fonts.zip -d ~/.fonts/
}
##########################################################
clear

echo "1.Pacman(Arch systems)"
echo "2.Apt(Debian, ubuntu, pop os..)"
echo "3.DNF(RHEL, Fedora..)"
echo "4.Custom"
printf "What package manager do you want to use:"
read -r osname
clear
folder_structure

if [[ $osname -eq 1 ]]; then
  pkg_manager="pacman"
  pkg_option="-S"
  pkg_confirm="--noconfirm"
  pkg_list="Files/Software/pacman.txt"
elif [[ $osname -eq 2 ]]; then
  pkg_manager="apt"
  pkg_option="install"
  pkg_confirm="-y"
  pkg_list="Files/Software/apt.txt"
elif [[ $osname -eq 3 ]]; then
  pkg_manager="dnf"
  pkg_option="install"
  pkg_confirm="-y"
  pkg_list="Files/Software/dnf.txt"
elif [[ $osname -eq 4 ]]; then
  printf "Enter your package manager(dnf, pacman, apt etc..): " ;
   read -r pkg_manager
  printf "Enter your package manager option used to install(-S in pacman, install in apt etc..): ";
   read -r pkg_option
  printf "Enter the Required tag for no confirm installation(optional): ";
   read -r pkg_confirm
  printf "Enter the absolute path to your package list: ";
   read -r pkg_list
fi

while true ; do
	clear
	echo "1.Themes"
	echo "2.Terminal"
	echo "3.Software"
	echo "4.fonts"
	echo "0.Quit"
	echo "9.Quit and reboot."
	printf "What do you want to start with: "; read -r task

	if [[ $task -eq 1 ]]; then
		set_themes
	elif [[ $task -eq 2 ]]; then
		set_terminal
	elif [[ $task -eq 3 ]]; then
    install_packages
	elif [[ task -eq 4 ]]; then
		install_fonts
	elif [[ $task -eq 0 ]]; then
		break
	elif [[ $task -eq 9 ]]; then
		chmod 755 ~/.fonts ~/.themes ~/.icons ~/.config
		rm -rf ~/temp
		sudo shutdown -r now
	fi

done
