function clean-brazil -d "Remove brazil cache"
  brazil-package-cache clean --days 0 --keepCacheHours 0
end
