# Fix the gst abbr
abbr --erase gst
abbr -a gst git st

if type -q sk
    skim_key_bindings
end

fish_vi_key_bindings

if type -q starship
    starship init fish | source
end
