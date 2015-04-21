#!/bin/sh

# Helper function for backing up and replacing configs
function replace_config {
	if [ -z "$1" ]
	then
		echo "No argument provided"
	fi

	# Check if the file already exists, if so move to backup
	if [ -e ~/"$1" ] 
	then
		mv ~/"$1" ~/"$1".bck
	fi

	ln -s `pwd`/"$1" ~/"$1"
}


git submodule init
git submodule update

# Replace or create the new configs
# If there is a conflict the existing one will be backed up and the new
# one will take its place
replace_config '.zshrc'
#replace_config '.gitconfig'
