FOUND_PYENV=0
pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv" "$HOME/.brew/bin/pyenv")

for pyenvdir in "${pyenvdirs[@]}" ; do
    if [ -d $pyenvdir/bin -a $FOUND_PYENV -eq 0 ] ; then
        FOUND_PYENV=1

        # We could use $pyenvdir as the PYENV_ROOT, but I'd rather always use
        # my home directory.
        export PYENV_ROOT=$HOME/.pyenv
        export PATH=${pyenvdir}/bin:$PATH
        eval "$(pyenv init --no-rehash - zsh)"
        pyenv virtualenvwrapper

        function pyenv_prompt_info() {
            echo "$(pyenv version-name)"
        }
    fi
done
unset pyenvdir

if [ $FOUND_PYENV -eq 0 ] ; then
    function pyenv_prompt_info() { echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')" }
fi
