for name in helix hx
    if which $name &>/dev/null
        set -gx HELIX $name
        break
    end
end
if ! type -q rust-analyzer; and type -q rustup
    fish_add_path (path dirname (rustup which rust-analyzer))
end
