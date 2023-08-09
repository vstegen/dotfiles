function assume-role -d "Assume role and output credentials"
  aws sts assume-role --role-arn $argv[1] --role-session-name test | tr '\n' ' ' | to-aws-env
end
