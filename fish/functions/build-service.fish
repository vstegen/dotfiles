function build-service -d "Build service stack"
  brazil-build clean

  set -x COMPUTE_SERVICE_DEV  "https://20vfo99edf.execute-api.eu-west-1.amazonaws.com/prod"
  set -x INTERNAL_SERVICE_DEV "https://o8d0eqigmk.execute-api.eu-west-1.amazonaws.com/prod"
  set -x CALLBACK_SERVICE_DEV  "https://w1fueytf40.execute-api.eu-west-1.amazonaws.com/prod"

  eda build brazil-build release
end
