output "bucket_names" {
  value = module.data_lake.bucket_names
}

output "spark_job_role_arn" {
  value = module.spark_job_role.role_arn
}
