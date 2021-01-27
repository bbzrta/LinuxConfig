#!/bin/bash
#by Arsham Rezaei
#
#


# Functions

# Creating the needed folder structure for -per user- configurations.
folder_structure () {
	mkdir /home/$USER/.fonts /home/$USER/.icons /home/$USER/.themes /home/$USER/temp
	chmod 777 /home/$USER/.fonts /home/$USER/.icons /home/$USER/.themes
	clear
}

# Setting the shell and icon theme in place
set_themes () {
	unzip themes.zip -d /home/$USER/.themes/
	wget "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/master.tar.gz" -P /home/$USER/temp/
	tar -xf /home/$USER/temp/master.tar.gz -C home/$USER/temp/
	mv ./*Papirus* /home/$USER/.icons/
	rm -rf /home/$USER/temp/*
}

# Downloading Alacritty on Arch based systems using pacman.
set_terminal () {
	mkdir ~/.config/alacritty 
	cp dotconfig/alacritty.yml ~/.config/alacritty/
	chsh "$USER" -s /bin/zsh
	mkdir ~/.terminal
	
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

	cp ./.zshrc ~/
}

# Installing all the needed packages
install_packages_arch(){
	
	xargs -a Files/Software/pacman.txt sudo pacman -S 
}
install_packages_debian(){
	xargs -a software.txt sudo apt install 
}
install_packages_fedora(){
	xargs -a software.txt sudo dnf install
}

install_fonts(){
	unzip ./fonts.zip -d ~/.fonts/

}
##########################################################
clear

echo "1.Arch"
echo "2.Debian"
echo "3.Fedora"
echo "What is the OS based on:"; read -r osname
clear
folder_structure

if [[ $osname -eq 3 ]]
then
	sudo dnf install util-linux-user
	sudo dnf install zsh
fi

while true ; do
	sleep 1
	clear
	echo "1.Themes"
	echo "2.Terminal"
	echo "3.Software"
	echo "4.fonts"
	echo "0.Quit"
	echo "9.Quit and reboot."
	echo "What do you want to start with:"
	read -r task
	sleep 1
	clear

	if [[ $task -eq 1 ]]
	then
		set_themes
	fi	

	if [[ $task -eq 2 ]]
	then
		set_terminal
		sleep 3
		clear
		echo YOU NEED TO ACTIVATE THE SYNTAX HIGHLIGHTING BY ADDING 'plugins=( [plugins...] zsh-syntax-highlighting)' to .ZSHRC
		sleep 5
		clear
		echo YOU NEED TO ACTIVATE POWERLEVEL10K BY ADDING 'powerlevel10k/powerlevel10k' IN FRONT OF 'ZSH_THEME=' in .ZSHRC
		sleep 5

	fi
	
	if [[ $task -eq 3 ]]
	then
		if [[ $osname -eq 1 ]]
		then
			install_packages_arch
		fi
	
		if [[ $osname -eq 2 ]]
		then
			install_packages_debian
		fi

		if [[ $osname -eq 3 ]]
		then
			install_packages_fedora
		fi
	fi

	if [[ task -eq 4 ]]
	then
		install_fonts
	fi

	if [[ $task -eq 0 ]]
	then
		break
	fi

	if [[ $task -eq 9 ]]
	then
		chmod 755 ~/.fonts ~/.themes ~/.icons ~/.config
		rm -rf ~/temp
		sudo shutdown -r now
	fi
done
