function wp-get-id
    set -l options n/names h/help
    argparse --ignore-unknown $options -- $argv
    or return 1

    if set -q _flag_help
        echo 'Usage: wp-get-id [-h|--help] [-n|--names] [ripgrep options]'
        return 0
    end

    if set -q _flag_names
        wpctl status | rg $argv
    else
        wpctl status | rg $argv | perl -nE 'say $1 if /(\d+)\./'
    end
end
