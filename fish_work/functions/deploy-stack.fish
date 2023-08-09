function deploy-stack -d "Deploy stack"
  brazil-build cdk deploy moontide-$argv[1]-$argv[2]-stack-dev-eu-west-1 --require-approval never
end
