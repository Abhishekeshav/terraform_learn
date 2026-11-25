variable "project" {
  description = "Short project name used in every resource name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be dev, qa or prod."
  }
}

variable "owner" {
  description = "Team that owns these resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "data_zones" {
  description = "Data lake zones; one bucket per zone"
  type        = set(string)
  default     = ["raw", "curated", "analytics"]

  validation {
    condition     = alltrue([for z in ["raw", "curated"] : contains(var.data_zones, z)])
    error_message = "data_zones must include raw and curated."
  }
}
