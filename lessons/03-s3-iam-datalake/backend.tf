terraform {
  backend "s3" {
   key  = "data-platform/dev/terraform.tfstate"
   use_lockfile = true
   encrypt = true
  }
} 
