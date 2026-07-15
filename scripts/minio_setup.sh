#!/bin/bash

# MinIO Setup Script for Socduacl
# This script creates the socduacl-public bucket and applies public-read policy
# It is idempotent - safe to run multiple times

set -e

# Load environment variables from .env if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Default values if not set
MINIO_ROOT_USER=${MINIO_ROOT_USER:-socduacl}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD:-socduacl_secret}
MINIO_ENDPOINT=${MINIO_ENDPOINT:-http://localhost:9000}
BUCKET_NAME=${BUCKET_NAME:-socduacl-public}

echo "MinIO Setup Script"
echo "==================="
echo "Endpoint: $MINIO_ENDPOINT"
echo "Bucket: $BUCKET_NAME"
echo ""

# Wait for MinIO to be ready
echo "Waiting for MinIO to be ready..."
until mc alias set local "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" > /dev/null 2>&1; do
    echo "MinIO not ready yet, retrying in 5 seconds..."
    sleep 5
done
echo "MinIO is ready"

# Create bucket if it doesn't exist
if mc ls local/"$BUCKET_NAME" > /dev/null 2>&1; then
    echo "Bucket '$BUCKET_NAME' already exists"
else
    mc mb local/"$BUCKET_NAME"
    echo "Bucket '$BUCKET_NAME' created successfully"
fi

# Apply public-read policy (download only)
mc anonymous set download local/"$BUCKET_NAME"
echo "Public-read policy applied to '$BUCKET_NAME'"

# Verify the policy
echo ""
echo "Verifying bucket policy..."
POLICY=$(mc anonymous get local/"$BUCKET_NAME")
echo "Current policy: $POLICY"

echo ""
echo "MinIO setup completed successfully"
