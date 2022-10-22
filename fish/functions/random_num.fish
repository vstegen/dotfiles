function random_num -d "Generate random 3 character number"
  cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 3 | head -n 1
end

