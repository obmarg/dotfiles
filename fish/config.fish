bass source ~/.profile

# Fix the gst abbr
abbr --erase gst
abbr -a gst git st

alias gpub='git push -u origin (git rev-parse --abbrev-ref HEAD)'
alias cdr='cd (git rev-parse --show-toplevel 2> /dev/null)'

if type -q sk
    status --is-interactive; and skim_key_bindings
end

fish_vi_key_bindings


if type -q starship
    status --is-interactive; and starship init fish | source
end

if type -q jj
    status --is-interactive; and jj debug completion --fish | source
end

if type -q nvim
    alias vim='nvim'
    alias vi='nvim'
    set -x EDITOR nvim
end

if type -q zoxide
    zoxide init fish | source
    alias cd='z'
    set -x _ZO_FZF_OPTS "--no-sort" "--keep-right" "--height=40%" "--info=inline" "--layout=reverse" "--exit-0" "--select-1" "--bind=ctrl-z:ignore" "--preview='ls {2..}'"
end

if type -q exa
    alias ls='exa'
end

if test -d ~/.brew/Cellar/asdf
    source (find ~/.brew/Cellar/asdf/*/asdf.fish)
end

set -x HUSKY 0

alias ffs='pushd (git rev-parse --show-toplevel 2>/dev/null) && yarn && yarn build:packages && popd'

# Created by `pipx` on 2021-11-24 16:37:56
set PATH $PATH /Users/graeme/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/graeme/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

if type -q atuin
    status --is-interactive; and atuin init fish | source
end

if type -q direnv
    direnv hook fish | source
end
