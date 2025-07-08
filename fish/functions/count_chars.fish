function count_chars -d "Count all characters in a directory"
    find . -type f -exec cat {} \; | tr -d '\n\r\t ' | fold -w1 | sort | uniq -c | sort -nr
end
