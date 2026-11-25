variable "name_prefix" {
  description = "Prefix for the role name, e.g. acme-dev"
  type        = string
}

variable "trusted_service" {
  description = "AWS service allowed to assume this role"
  type        = string
  default     = "emr-serverless.amazonaws.com"
}

variable "read_bucket_arns" {
  description = "Buckets the job may read from"
  type        = list(string)

  validation {
    condition     = length(var.read_bucket_arns) > 0
    error_message = "Provide at least one bucket to read from."
  }
}

variable "write_bucket_arns" {
  description = "Buckets the job may write to"
  type        = list(string)

  validation {
    condition     = length(var.write_bucket_arns) > 0
    error_message = "Provide at least one bucket to write to."
  }
}
