output "bucket_names" {
  description = "Map of zone => bucket name"
  value       = { for zone, b in aws_s3_bucket.zone : zone => b.bucket }
}

output "bucket_arns" {
  description = "Map of zone => bucket ARN"
  value       = { for zone, b in aws_s3_bucket.zone : zone => b.arn }
}
