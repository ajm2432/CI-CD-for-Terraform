variable "codebuild-Security-Check-role" {
  description = "iam role for security check codebuild"
  type        = string
  default     = ""
}

variable "codebuild-tf-plan-role" {
  description = "iam role for tf-plan codebuild"
  type        = string
  default     = ""
}

variable "codebuild-TerraformCommit-role" {
  description = "iam role for tf-apply codebuild"
  type        = string
  default     = ""
}

variable "example-tf-Pipeline-role" {
  description = "iam role for tf pipeline"
  type        = string
  default     = ""
}

variable "artifact_location" {
  description = "s3 bucket for artifacts to be stored"
  type        = string
  default     = ""
}
variable "region" {
  description = "aws region"
  type        = string
  default     = ""
}
variable "connection_name" {
  description = "name of connection"
  type        = string
  default     = ""
}

variable "pipeline_name" {
  description = "name of CI/CD pipeline"
  type        = string
  default     = ""
}

variable "full_repo_name" {
  description = "name of github repo"
  type        = string
  default     = ""
}
variable "git_hub_url" {
  description = "name of github url"
  type        = string
  default     = ""
}
