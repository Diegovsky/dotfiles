function wp-get-id
    set -l options n/names h/help a/all
    argparse --ignore-unknown $options -- $argv
    or return 1

    if set -q _flag_help
        echo 'Usage: wp-get-id [-h|--help] [-n|--names] [] [ripgrep options]'
        return 0
    end

    set filters "rg $argv"

    if not set -q _flag_all
        set -a filters 'rg "vol:"'
    end

    if set -q _flag_names
        set perl_filter "(\d+\. [^\[]+)"
    else
        set perl_filter "(\d+)\."
    end
    set -a filters "perl -nE 'say trim(\$1) if /$perl_filter/'"

    set output "$(wpctl status)"
    echo $output | eval (string join ' | ' $filters)
end
