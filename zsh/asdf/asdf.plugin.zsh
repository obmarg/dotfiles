if [ ! -d ~/.asdf ] ; then
    if [ ! -z $PS1 ] ; then
        echo "ASDF is not installed"
        read -q "REPLY?Do you wish to install? [y/n] "
        echo
        if [[ $REPLY == "y" ]] ; then
            git clone https://github.com/HashNuke/asdf.git ~/.asdf
        fi
        echo
    fi
fi

if [ -s ~/.asdf/asdf.sh ] ; then
    . ~/.asdf/asdf.sh

    ASDF_PLUGINS=`asdf plugin-list`

    if [ -z $PS1 ] ; then
        return 0
    fi

    if [[ ! $ASDF_PLUGINS == *"elixir"* ]] ; then
        echo "ASDF elixir plugin is not installed"
        read -q "REPLY?Do you wish to install? [y/n] "
        echo
        if [[ $REPLY == "y" ]] ; then
            asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git
        fi
        echo
    fi

    if [[ ! $ASDF_PLUGINS == *"erlang"* ]] ; then
        echo "ASDF erlang plugin is not installed"
        read -q "REPLY?Do you wish to install? [y/n] "
        echo
        if [[ $REPLY == "y" ]] ; then
            asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
        fi
        echo
    fi

    if [[ ! $ASDF_PLUGINS == *"nodejs"* ]] ; then
        echo "ASDF nodejs plugin is not installed"
        read -q "REPLY?Do you wish to install? [y/n] "
        echo
        if [[ $REPLY == "y" ]] ; then
            asdf plugin-add nodejs https://github.com/HashNuke/asdf-nodejs.git
        fi
        echo
    fi

    if [[ ! $ASDF_PLUGINS == *"elm"* ]] ; then
        echo "ASDF elm plugin is not installed"
        read -q "REPLY?Do you wish to install? [y/n] "
        echo
        if [[ $REPLY == "y" ]] ; then
            asdf plugin-add elm https://github.com/obmarg/asdf-elm.git
        fi
        echo
    fi
fi
