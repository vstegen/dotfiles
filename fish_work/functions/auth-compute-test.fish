function auth-compute-test -d "Get credentials for compute tests in Beta"
  ada credentials update --once --account=381849200033 --provider=isengard --role=Admin

  set -xg AWS_REGION "eu-west-1"
  set -xg STAGE "beta"
  set -xg NO_ACCESS_ACCOUNT "687724418387"
  set -xg GENERAL_TEST_ACCOUNT "530669891190"
  set -xg MDE_SERVICE_AWS_ACCOUNT "071424567641"
  set -e DEV_AWS_ACCOUNT 
end
