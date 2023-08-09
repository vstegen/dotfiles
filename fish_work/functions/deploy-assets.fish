function deploy-assets -d "Deploy assets"
  brazil-build deploy:assets -i moontide-$argv[1]-$argv[2]-stack-dev-eu-west-1
end
