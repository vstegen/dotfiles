function clear-cache -d "Delete BATS and Brazil cache"
    bats cache --clear-cache
    brazil-package-cache clean # --days 0 --keepCacheHours 0
end
