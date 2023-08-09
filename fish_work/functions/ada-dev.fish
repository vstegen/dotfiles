function ada-dev -d "Get dev credentials"
    ada credentials update --once --account=$DEV_ACCOUNT --provider=isengard --role=Admin

    set -gx DEV_AWS_ACCOUNT $(aws sts get-caller-identity --query Account --output text)

    set -gx AWS_REGION eu-west-1

    set -gx STAGE dev

    set -gx MDE_ENDPOINT "https://pbkbbfm20i.execute-api.eu-west-1.amazonaws.com/prod";

    set -gx MDE_ENDPOINT_LEGACY "https://16861198a8.execute-api.eu-west-1.amazonaws.com/prod";

    set -gx CREDENTIALS_VENDING_SERVICE_ENDPOINT_DEV "https://jtl3jl0nx6.execute-api.eu-west-1.amazonaws.com/prod"

    set -gx INTERNAL_SERVICE_ENDPOINT_DEV "https://o8d0eqigmk.execute-api.eu-west-1.amazonaws.com/prod"
    set -gx INTERNAL_SERVICE_DEV "https://o8d0eqigmk.execute-api.eu-west-1.amazonaws.com/prod"

    set -gx COMPUTE_SERVICE_DEV "https://20vfo99edf.execute-api.eu-west-1.amazonaws.com/prod"

    set -gx CALLBACK_SERVICE_API_GW_ID_DEV "1vc7ztpyei"

    set -gx DEV_WARMPOOL_SERVICE_ENDPOINT "https://k199yvhxf8.execute-api.eu-west-1.amazonaws.com/prod"

    set-ecr
    ssh-add ~/.ssh/id_rsa
end
