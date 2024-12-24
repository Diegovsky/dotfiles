function webm-to-wpp --argument webm mp4
    if test -z "$webm"
        echo "Expected webm file to convert."
        return 1
    end

    if test -z "$mp4"
        set mp4 $(path change-extension .mp4 $webm)
    end

    
    if not ffmpeg -fflags +genpts -i $webm $mp4
        echo set_color red; echo 'Conversion failed' set_color normal;
    end

    set_color green; echo Saved file as $mp4.; set_color normal;
    switch (read -p 'set_color blue; echo Open file\? [Y/n]; set_color normal')
        case y Y
            xdg-open $mp4
    end

    cb copy $mp4
end
