function random_string -d "Generate random 8 character string"
  cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 8 | head -n 1
end
