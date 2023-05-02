function unset-creds -d "Remove env vars for AWS credentials"
  set -e AWS_ACCESS_KEY_ID
  set -e AWS_SESSION_TOKEN
  set -e AWS_SECRET_ACCESS_KEY
end
