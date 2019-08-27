#!/usr/bin/env bash
#
# Init variables
AWS_REGION=$(${SCRIPTS}/read_cfg.sh $HOME/.aws/config "profile ${ROOT_AWS_PROFILE}" region)
AWS_PROFILE=${AWS_PROFILE:-root}
ROOT_AWS_PROFILE=${ROOT_AWS_PROFILE:-root}
ACCOUNT_NAME=${ACCOUNT_NAME:-root}
NAMESPACE=$1

BUCKET_NAME=tf-remote-state-0df9r432
KMS_KEY_ALIAS=alias/root-key
DB_TABLE=terraform-remote-state-locking

if [ $ACCOUNT_NAME = "root" ]; then
  # Create remote state S3 bucket
  if aws s3 ls --profile $ROOT_AWS_PROFILE | grep $BUCKET_NAME > /dev/null 2>&1; then
    echo "Remote state bucket $BUCKET_NAME alrwady exists. Skipping..." > /dev/null 2>&1
  else
    aws s3api create-bucket --bucket $BUCKET_NAME --profile $ROOT_AWS_PROFILE
  fi

  # Create remote kms key
  if aws kms list-aliases --output text --profile $ROOT_AWS_PROFILE | grep $KMS_KEY_ALIAS > /dev/null 2>&1; then
    echo "KMS key $KMS_KEY_ALIAS alrwady exists. Skipping..." > /dev/null 2>&1
    AWS_KMS_KEY_ID=$(aws --profile $ROOT_AWS_PROFILE kms describe-key --key-id $KMS_KEY_ALIAS | jq --raw-output '.KeyMetadata.KeyId')
  else
    AWS_KMS_KEY_ID=$(aws kms create-key \
        --description "KMS key used to encrypt and decrypt remote state file" \
        --key-usage ENCRYPT_DECRYPT \
        --profile $ROOT_AWS_PROFILE \
        | jq --raw-output '.KeyMetadata.KeyId')
    # Create key alias
    aws kms create-alias --alias-name $KMS_KEY_ALIAS --target-key-id $AWS_KMS_KEY_ID
  fi

  # Create remote state dynamodb table
  if aws dynamodb list-tables --profile $ROOT_AWS_PROFILE --output text | grep $DB_TABLE > /dev/null 2>&1; then
    echo "Remote state dynamodb table $DB_TABLE alrwady exists. Skipping..." > /dev/null 2>&1
  else
    aws dynamodb create-table \
        --table-name $DB_TABLE \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=10 \
        --profile $ROOT_AWS_PROFILE
  fi
fi


  cat <<BACKEND
  #=====================================#
  # Terraform Remote State - Backend
  #=====================================#
  terraform {
    required_version = ">= 0.12.6"
    backend "s3" {
      region         = "${AWS_REGION}"
      encrypt        = true
      bucket         = "${BUCKET_NAME}"
      key            = "${ACCOUNT_NAME}/${NAMESPACE}/terraform.tfstate"
      kms_key_id     = "${AWS_KMS_KEY_ID}"
      profile        = "${ROOT_AWS_PROFILE}"
      dynamodb_table = "${DB_TABLE}"
    }
  }

BACKEND
