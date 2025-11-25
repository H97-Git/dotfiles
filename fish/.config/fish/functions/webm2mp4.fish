function webm2mp4 --description 'Convert .webm to .mp4 using ffmpeg'
    if test (count $argv) -lt 1
        echo "Usage: webm2mp4 <sourcefile.webm>"
        return 1
    end

    set -l src $argv[1]

    if not test -f $src
        echo "Error: file not found — $src"
        return 1
    end

    set -l base (string replace -r '\.webm$' '' (basename $src))
    set -l dst "$base.mp4"

    echo "Converting: $src → $dst"
    ffmpeg -fflags +genpts -i "$src" -r 24 "$dst"
end
