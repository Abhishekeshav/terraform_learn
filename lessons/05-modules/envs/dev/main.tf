locals {
  project     = "acme-mod"
  environment = "dev"
  name_prefix = "${local.project}-${local.environment}"

  common_tags = {
    project     = local.project
    environment = local.environment
    owner       = "data-engineering"
    managed_by  = "terraform"
  }
}

module "data_lake" {
  source = "../../modules/data_lake"

  name_prefix   = local.name_prefix
  zones         = ["raw", "curated", "analytics"]
  force_destroy = true # LEARNING ONLY: never true for real data
}

module "spark_job_role" {
  source = "../../modules/spark_job_role"

  name_prefix       = local.name_prefix
  read_bucket_arns  = [module.data_lake.bucket_arns["raw"]]
  write_bucket_arns = [module.data_lake.bucket_arns["curated"]]
}
