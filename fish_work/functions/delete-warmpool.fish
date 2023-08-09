function delete-warmpool -d "Delete Warmpool by ID"
  aws mde delete-warm-pool --warm-pool-id $argv[1] --region $AWS_REGION --endpoint $MDE_ENDPOINT
end
