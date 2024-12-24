function update-mirrors
    sudo reflector -c Brazil --sort rate -l 5 -f 5 --completion-percent 85 --save /etc/pacman.d/mirrorlist
end
