output "bucket_names" {
  value = { for zone, b in aws_s3_bucket.zone : zone => b.bucket }
}

output "spark_job_role_arn" {
  value = aws_iam_role.spark_job.arn
}
