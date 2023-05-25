function remove_ds_store -d "Removes all .DS_Store files in ~/.asdf/install"
  find /opt/homebrew/lib -name '.DS_Store' -type f -print -delete
end
