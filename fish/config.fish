# Fix the gst abbr
abbr --erase gst
abbr -a gst git st

if type -q sk
    skim_key_bindings
end

starship init fish | source
