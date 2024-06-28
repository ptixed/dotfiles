function rm
    set trash "$HOME/.local/share/trash"

    for file in $argv
        if ! test -e "$file"
            echo "cannot remove '$file': No such file or directory" 
            return 1
        end
    end

    for file in $argv
        set abs (path resolve "$file")
        set filename (path basename "$file")
        set dir (path dirname "$abs") 

        set suffix ''
        while test -e "$trash$dir/$filename$suffix"
            set suffix (math "$suffix+1")
        end

        mkdir -p "$trash$dir"
        mv "$file" "$trash$dir/$filename$suffix"
    end
end
