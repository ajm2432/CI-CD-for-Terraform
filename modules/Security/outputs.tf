output "aws_kms_key" {
  value = aws_kms_key.exampleKey.arn
}
output "security_check_iam_role" {
  value = aws_iam_role.codebuild-Security-Check-service-role.arn
}
output "tf_plan_iam_role" {
  value = aws_iam_role.codebuild-TerraformPlan-service-role.arn
}
output "tf_apply_iam_role" {
  value = aws_iam_role.codebuild-TerraformCommit-service-role.arn
}
output "tf_pipeline_iam_role" {
  value = aws_iam_role.example-tf-Pipeline.arn
}

