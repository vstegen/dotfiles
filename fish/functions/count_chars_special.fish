function count_chars_special -d "Count all characters in a directory"
    find . -type f -exec file {} \; | grep -E 'text|ASCII' | cut -d: -f1 | xargs cat | tr -d "[:upper:]" | tr -d "[:lower:]" | tr -d "[:digit:]" | fold -w1 | sort | uniq -c | sort -nr
end
