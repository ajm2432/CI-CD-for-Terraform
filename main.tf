data "aws_availability_zones" "available" {
  state = "available"
}
################################################################################
# IAM Module
################################################################################
module "security" {
  source                     = "./modules/Security"
  region                     = "${var.region}"
  pipeline_policy_name       = "prod-pipeline-policy"
  tf-plan_policy_name        = "prod-tf-plan-policy"
  security_check_policy_name = "prod-sec-check-policy"
  tf-apply_policy_name       = "prod-tf-apply-policy"
  pipeline_role_name         = "prod-pipeline-role"
  tf-plan_role_name          = "prod-tf-plan-role"
  security_check_role_name   = "prod-sec-check-role"
  tf-apply_role_name         = "prod-tf-apply-role"
  sec_check_report           = "prod-sec-check-report"
  tf-plan_report             = "prod-tf-plan-report"
  tf-apply_report            = "prod-tf-apply-report"
  
}
 ################################################################################
 # S3 Module
 ################################################################################
 module "s3" {
   source                    = "./modules/S3"
   log_bucket_name           = "logbucket-tf-${var.region}-logs"
   pipeline_bucket_name      = "tf-pipeline-artifacts-${var.region}"
   kms_key                   = "${module.security.aws_kms_key}"
 } 
 ################################################################################
 # Create CI/CD Pipeline
 ################################################################################
module "pipelines" {
  source                         = "./modules/CodePipelines"
  connection_name                = "prod-example-tf"
  full_repo_name                 = "ajm2432/TerraformTest"#Change to your user and repository
  git_hub_url                    = "https://github.com/ajm2432/TerraformTest.git"# Change to Match User and repository
  pipeline_name                  = "prod-example-tf-pipeline" 
  region                         = "${var.region}"
  codebuild-Security-Check-role  = "${module.security.security_check_iam_role}"
  codebuild-tf-plan-role         = "${module.security.tf_plan_iam_role}"
  codebuild-TerraformCommit-role = "${module.security.tf_apply_iam_role}"
  example-tf-Pipeline-role       = "${module.security.tf_pipeline_iam_role}"
  artifact_location              = "${module.s3.aws_pipeline_bucket}"
  kms_key                        = "${module.security.aws_kms_key}"
}
