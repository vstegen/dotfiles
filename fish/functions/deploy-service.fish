function deploy-service -d "Deploy service infrastructure"
  ada-dev

  brazil-build cdk deploy --hotswap Lambda-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap Internal-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap InternalControlPlane-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap StepFunctions-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap DynamoStreams-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap CustomerMetrics-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap Testing-dev-${AWS_REGION} --require-approval never
  brazil-build cdk deploy --hotswap WarmPools-dev-${AWS_REGION} --require-approval never
end
