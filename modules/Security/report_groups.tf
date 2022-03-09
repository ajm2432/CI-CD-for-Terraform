######################################
#CodeBuild sec_check report group
######################################
resource "aws_codebuild_report_group" "sec_check" {
  name = var.sec_check_report
  type = "TEST"

  export_config {
    type = "NO_EXPORT"
}
}

######################################
#CodeBuild tf-apply report group
######################################
resource "aws_codebuild_report_group" "tf-apply" {
  name = var.tf-apply_report
  type = "TEST"

  export_config {
    type = "NO_EXPORT"
}
}

######################################
#CodeBuild tf-plan report group
######################################
resource "aws_codebuild_report_group" "tf-plan" {
  name = var.tf-plan_report
  type = "TEST"

  export_config {
    type = "NO_EXPORT"
}
}
