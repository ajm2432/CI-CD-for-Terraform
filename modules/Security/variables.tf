variable "pipeline_policy_name" {
  description = "policy name for pipeline policy"
  type        = string
  default     = ""
}
variable "tf-plan_policy_name" {
  description = "policy name for tf-plan policy"
  type        = string
  default     = ""
}
variable "security_check_policy_name" {
  description = "policy name for security_check policy"
  type        = string
  default     = ""
}

variable "tf-apply_policy_name" {
  description = "policy name for tf-apply policy"
  type        = string
  default     = ""
}
variable "pipeline_role_name" {
  description = "role name for pipeline role"
  type        = string
  default     = ""
}
variable "tf-plan_role_name" {
  description = "role name for tf-plan role"
  type        = string
  default     = ""
}
variable "security_check_role_name" {
  description = "role name for security_check role"
  type        = string
  default     = ""
}
variable "tf-apply_role_name" {
  description = "role name for tf-apply role"
  type        = string
  default     = ""
}
variable "image_builder_role_name" {
  description = "role name for tf-apply role"
  type        = string
  default     = ""
}
variable "sec_check_report" {
  description = "name for sec_check build report group"
  type        = string
  default     = ""
}

variable "tf-apply_report" {
  description = "name for sec_check build report group"
  type        = string
  default     = ""
}

variable "tf-plan_report" {
  description = "name for sec_check build report group"
  type        = string
  default     = ""
}

variable "log_bucket_name" {
  description = "bucket for logs"
  type        = string
  default     = ""
}

variable "pipeline_bucket_name" {
  description = "bucket for pipeline artifacts"
  type        = string
  default     = ""
}
variable "region" {
  description = "aws region"
  type        = string
  default     = ""
}
