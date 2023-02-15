#/usr/bin/env bash

if ! command -v gum &> /dev/null
then
    echo "Installing gum"
    brew install gum
fi

if [[ ! -e ~/.gitconfig  ]]
then
	echo "Linking ~/.gitconfig"
	ln -s $(pwd)/_gitconfig ~/.gitconfig
fi

if (gum confirm "Do you want to configure fish?")
then
	mkdir -p ~/.config
	ln -s $(pwd)/fish ~/.config
	echo "You might have to install OMF yourself: https://github.com/oh-my-fish/oh-my-fish"
	echo "Then install bass with \"omf install bass\""
fi

if (gum confirm "Do you want to configure starship?")
then
	mkdir -p ~/.config
	if ! command -v starship &> /dev/null
	then
		echo "Installing starship.toml"
		brew install starship
	fi
	if [[ ! -e ~/.config/starship.toml ]]
	then
		echo "Linking starship.toml"
		ln -s $(pwd)/starship.toml ~/.config
	fi
fi

if (gum confirm "Ensure various things from homebrew are installed?")
then
	echo "Installing diff-so-fancy"
	brew install diff-so-fancy
	echo "Installing nvim"
	brew install nvim
fi
