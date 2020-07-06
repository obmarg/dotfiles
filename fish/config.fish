fenv source ~/.profile

# Fix the gst abbr
abbr --erase gst
abbr -a gst git st

alias gpub='git push -u origin (git rev-parse --abbrev-ref HEAD)'
alias cdr='cd (git rev-parse --show-toplevel 2> /dev/null)'

if type -q sk
    skim_key_bindings
end

fish_vi_key_bindings

if type -q starship
    starship init fish | source
end

if test -d ~/.brew/Cellar/asdf
    source (find ~/.brew/Cellar/asdf/*/asdf.fish)
end
