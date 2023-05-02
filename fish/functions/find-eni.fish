function find-eni -d "Find Lamda that uses the ENI"
  $HOME/bin/aws-support-tools/Lambda/FindEniMappings/findEniAssociations --region $AWS_REGION --eni $args[1]
end
