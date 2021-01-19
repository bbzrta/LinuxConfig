#!/bin/bash
# Functions

# Creating the needed folder structure for -per user- configurations.
folder_structure () {
	mkdir ~/.fonts ~/.icons ~/.themes ~/temp
	chmod 777 ~/.fonts ~/.icons ~/.themes
	clear
}

# Setting the shell and icon theme in place
set_themes () {
	wget "https://dllb2.pling.com/api/files/download/id/1581918005/s/67e16051c2ab09ba262689b163ec038579f2f2f743fa8e91
	a4e31a5ae2a35af63ba53a0740424787f07f81645993743c5725f9563856e24cb8fdfa93f4bd26aa/t/1610761826/u/322444/Orchis-com
	pact.tar.xz" -P ~/temp/
	
	tar -xf ~/temp/Orchis-compact.tar.xz -C ~/.themes
	rm -rf ~/temp/*
	
	wget "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/master.tar.gz" -P ~/temp/
	tar -xf ~/temp/master.tar.gz -C ~/temp/
	mv ./*Papirus* ~/.icons/
	rm -rf ~/temp/*
}

# Downloading Alacritty on Arch based systems using pacman.
set_terminal_arch () {
	sudo pacman -Sy alacritty zsh
	mv dotconfig/alacritty.yml ~/.config
	chsh "$USER" -s /bin/zsh
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
	mkdir ~/.Terminal
	cd ~/.Terminal
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
	echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
	source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}
set_terminal_debian (){
	sudo apt install alacritty zsh
	mv dotconfig/alacritty.yml ~/.config
	chsh "$USER" -s /bin/zsh
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.Terminal/powerlevel10k
	echo 'source ~/.Terminal/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
	mkdir ~/.Terminal
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.Terminal/zsh-syntax-highlighting
	echo "source ~/.Terminal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
	source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}
set_terminal_fedora (){
	sudo dnf install alacritty zsh
	mv dotconfig/alacritty.yml ~/.config
	chsh "$USER" -s /bin/zsh
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
	mkdir .Terminal
	cd .Terminal
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
	echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $
{ZDOTDIR:-$HOME}/.zshrc
	source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

# Installing all the needed packages
install_packages_arch(){
	xargs -a software.txt sudo pacman -S 
}
install_packages_debian(){
	xargs -a software.txt sudo apt install 
}
install_packages_fedora(){
	xargs -a software.txt sudo dnf install
}

install_fonts(){
	cp ./fonts/* ~/.fonts
}
##########################################################
clear

echo "1.Arch"
echo "2.Debian"
echo "3.Fedora"
echo "What is the OS based on:"; read -r osname
clear
folder_structure

while true ; do
	clear

	echo "1.Themes"
	echo "2.Terminal"
	echo "3.Software"
	echo "4.fonts"
	echo "0.Quit"
	echo "9.Quit and reboot."
	echo "What do you want to start with:"
	read -r task
	clear

	if [[ $task -eq 1 ]]
	then
		set_themes
	fi	

	if [[ $task -eq 2 ]]
	then
		if [[ $osname -eq 1 ]]
		then
			set_terminal_arch
		fi

		if [[ $osname -eq 2 ]]
		then
			set_terminal_debian
		fi

		if [[ $osname -eq 3 ]]
		then
			set_terminal_fedora
		fi
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
