variable "name_prefix" {
  description = "Prefix for bucket names, e.g. acme-dev"
  type        = string
}

variable "zones" {
  description = "Data lake zones; one bucket per zone"
  type        = set(string)
}

variable "noncurrent_version_days" {
  description = "Days to keep old object versions before deleting them"
  type        = number
  default     = 30
}

variable "force_destroy" {
  description = "Allow destroy to delete non-empty buckets. Keep false outside of practice."
  type        = bool
  default     = false
}
