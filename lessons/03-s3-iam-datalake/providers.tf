provider "aws" {
  region = var.aws_region

  # Every resource gets these tags automatically.
  default_tags {
    tags = local.common_tags
  }
}
