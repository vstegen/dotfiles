function init -d "Initialize asdf versions"
  asdf direnv local nodejs $(node -v)
end
