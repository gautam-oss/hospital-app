#!/bin/bash
ENV=${1:-dev}
REGION=ap-south-1
ACCOUNT=208179291544
BUCKET="tf-state-${ENV}-${ACCOUNT}"
TABLE="tf-locks-${ENV}"
echo "→ Creating S3 bucket: $BUCKET"
aws s3api create-bucket --bucket $BUCKET \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION \
  --profile $ENV
aws s3api put-bucket-versioning --bucket $BUCKET \
  --versioning-configuration Status=Enabled --profile $ENV
aws s3api put-bucket-encryption --bucket $BUCKET \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' \
  --profile $ENV
echo "→ Creating DynamoDB table: $TABLE"
aws dynamodb create-table \
  --table-name $TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION --profile $ENV
echo "✅ Done — $BUCKET + $TABLE ready"
