variable "log_bucket_name" {
  description = "bucket for logs"
  type        = string
  default     = ""
}
variable "kms_key" {
  description = "kms key for bucket logs"
  type        = string
  default     = ""
}
variable "pipeline_bucket_name" {
  description = "bucket for pipeline artifacts"
  type        = string
  default     = ""
}
