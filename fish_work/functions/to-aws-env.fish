function to-aws-env -d "Get AWS credentials from input"
  read input

  set -l accessKey $(echo "${input}" | jq .Credentials.AccessKeyId)
  set -l secretKey $(echo "${input}" | jq .Credentials.SecretAccessKey)
  set -l sessionToken $(echo "${input}" | jq .Credentials.SessionToken)
  
  echo "set -gx AWS_ACCESS_KEY_ID ${accessKey}"
  echo "set -gx AWS_SECRET_ACCESS_KEY ${secretKey}"
  echo "set -gx AWS_SESSION_TOKEN ${sessionToken}"
end
