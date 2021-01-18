#!/bin/bash

# Functions

folder_structure () {
	mkdir ~/.fonts ~/.icons ~/.themes ~/temp
	chmod 777 ~/.fonts ~/.icons ~/.themes
}

set_themes () {
	wget "https://dllb2.pling.com/api/files/download/id/1581918005/s/67e16051c2ab09ba262689b163ec038579f2f2f743fa8e91
	a4e31a5ae2a35af63ba53a0740424787f07f81645993743c5725f9563856e24cb8fdfa93f4bd26aa/t/1610761826/u/322444/Orchis-com
	pact.tar.xz" -P ~/temp/
	
	tar -xf ~/temp/Orchis-compact.tar.xz -C ~/.themes
	rm -rf ~/temp/*
	
	wget "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/master.tar.gz" -P ~/temp/
	tar -xf ~/temp/master.tar.gz -C ~/temp/
	mv *Papirus* ~/.icons/
	rm -rf ~/temp/*
}

set_terminal_arch () {
	sudo pacman -Sy alacritty 
}
echo "What is the OS based on?"
echo "1.Arch"
echo "2.Debian"
echo "3.Fedora"

read osname

if [[ $osname -eq 1 ]]
then
	echo "Loading..."

	echo "What do you want to start with?"
	echo "1.Themes"
	echo "2.Terminal"
	echo "3.Software"
