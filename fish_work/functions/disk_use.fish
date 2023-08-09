function disk_use -d "Get top 10 largest directories"
  # can also use -hax here
  du -hsx * | sort -rh | head -10
end
