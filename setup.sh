#/usr/bin/env bash

if ! command -v gum &> /dev/null
then
    echo "Installing gum"
    brew install gum
fi

if (gum confirm "Do you want to configure fish?")
then
	mkdir -p ~/.config
	ln -s $(pwd)/fish ~/.config
	echo "You might have to install OMF yourself: https://github.com/oh-my-fish/oh-my-fish"
	echo "Then install bass with `omf install bass`"
fi

if (gum confirm "Do you want to configure starship?")
then
	mkdir -p ~/.config
	if [[ ! -e ~/.config/starship.toml ]]
	then
		ln -s $(pwd)/starship.toml ~/.config
	fi
	if ! command -v starship &> /dev/null
	then
		brew install starship
	fi
fi
