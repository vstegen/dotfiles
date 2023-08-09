function ssh -d "SSH override"
    set-title $argv;
    /usr/bin/ssh -2 $argv;
    set-title $HOST;
end
