terraform {
  backend "s3" {
    key          = "data-platform-v2/dev/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}
