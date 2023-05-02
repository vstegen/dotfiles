function set-title -d "Title"
    echo -e "\e]0;$argv\007"
end
