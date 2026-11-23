# Smoke test: proves Terraform -> LocalStack works. Use from Day 3.
#
#   ../../scripts/localstack-start.sh
#   terraform init && terraform apply
#   aws --profile localstack s3 ls
#   terraform destroy
#
# LEARNING-ONLY settings are marked below. They exist because LocalStack is a
# fake AWS. Never copy them into real-AWS code.

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # LEARNING-ONLY: dummy credentials that LocalStack accepts.
  access_key = "test"
  secret_key = "test"

  # LEARNING-ONLY: skip calls that only real AWS can answer.
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # LEARNING-ONLY: send every API call to LocalStack instead of AWS.
  s3_use_path_style = true
  endpoints {
    s3             = "http://localhost:4566"
    iam            = "http://localhost:4566"
    sts            = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
  }

  default_tags {
    tags = {
      project     = "tf-de-practice"
      environment = "local"
      managed_by  = "terraform"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "raw" {
  bucket = "de-raw-${random_id.suffix.hex}"

  # LEARNING-ONLY: lets destroy delete a bucket that still has files.
  # In production, data buckets should never have this.
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "raw_bucket_name" {
  value = aws_s3_bucket.raw.bucket
}
