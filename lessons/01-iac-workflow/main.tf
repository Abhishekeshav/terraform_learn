# Lesson 1.1: Infrastructure as Code and the core workflow
# No cloud account needed. Everything happens inside this folder.
#
#   terraform init      -> download providers
#   terraform fmt       -> format code
#   terraform validate  -> check syntax
#   terraform plan      -> preview changes
#   terraform apply     -> make changes, write terraform.tfstate
#   terraform destroy   -> remove everything in state

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# Generates a random suffix once and remembers it in state.
# Real-world reason: S3 bucket names must be globally unique.
resource "random_id" "suffix" {
  byte_length = 4
}

# Writes a pipeline config file. Referencing random_id.suffix.hex creates an
# implicit dependency: Terraform creates the random_id first.
resource "local_file" "pipeline_config" {
  filename = "${path.module}/output/pipeline_config.json"
  content = jsonencode({
    pipeline    = "sales_ingestion"
    environment = "dev"
    raw_bucket  = "de-raw-${random_id.suffix.hex}"
  })
}

output "raw_bucket_name" {
  value = "de-raw-${random_id.suffix.hex}"
}
