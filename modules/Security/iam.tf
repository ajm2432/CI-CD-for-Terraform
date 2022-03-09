
###################################################
# Data for current account id
###################################################
data "aws_caller_identity" "current" {
}
###################################################
#CodeBuild tf apply IAM role
###################################################
resource "aws_iam_role" "codebuild-TerraformCommit-service-role" {
  assume_role_policy    = file("./modules/files/codebuild-assume.json")
  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = var.tf-apply_role_name
  path                  = "/"
  tags                  = {}
  tags_all              = {}

  
}
###################################################
#CodeBuild security IAM role
###################################################
resource "aws_iam_role" "codebuild-Security-Check-service-role" {
  assume_role_policy    = file("./modules/files/codebuild-assume.json")
  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false  
  max_session_duration = 3600
  name                 = var.security_check_role_name
  path                 = "/"
  tags                 = {}
  tags_all             = {}

  
}
###################################################
#CodeBuild tf plan IAM role
###################################################
resource "aws_iam_role" "codebuild-TerraformPlan-service-role" {
  assume_role_policy    = file("./modules/files/codebuild-assume.json")
  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false
  max_session_duration = 3600
  name                 = var.tf-plan_role_name
  path                 = "/"
  tags                 = {}
  tags_all             = {}
 
  
}
###################################################
#CodePipeline IAM role
###################################################
resource "aws_iam_role" "example-tf-Pipeline" {
  assume_role_policy    = file("./modules/files/codepipeline-assume.json")
  description           = "Allows CodePipeline to call AWS services on your behalf."
  force_detach_policies = false
  max_session_duration = 3600
  name                 = var.pipeline_role_name
  path                 = "/"
  tags                 = {}
  tags_all             = {}

  
}

###################################################
#CodePipeline tf IAM policy
###################################################
resource "aws_iam_policy" "example-tf-Pipeline" {
  description = "Policy used in trust relationship with CodePipeline"
  name        = var.pipeline_policy_name
  path        = "/service-role/"
  policy      = file("./modules/files/codepipeline-policy.json")  
}
###################################################
#CodeBuild tf apply IAM policy
###################################################
resource "aws_iam_policy" "CodeBuildBasePolicy-TerraformApply" {
  description = "Policy used in trust relationship with CodeBuild"
  name        = var.tf-apply_policy_name
  path        = "/service-role/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
          ]
          Effect = "Allow"
          "Resource" = [
            "arn:aws:s3::*:*pipeline*",
          ]
        },
        {
          Action = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages",
          ]
          Effect = "Allow"
          "Resource" = [
            "${aws_codebuild_report_group.tf-apply.arn}",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
    depends_on = [
    aws_kms_key.exampleKey
  ]
}
###################################################
#CodeBuild tf plan IAM policy
###################################################
resource "aws_iam_policy" "CodeBuildBasePolicy-TerraformPlan" {
  description = "Policy used in trust relationship with CodeBuild"
  name        = var.tf-plan_policy_name
  path        = "/service-role/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
          ]
          Effect = "Allow"
          "Resource" = [
            "arn:aws:s3::*:*pipeline*/*",
          ]
        },
        {
          Action = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages",
          ]
          Effect = "Allow"
          "Resource" = [
            "${aws_codebuild_report_group.tf-plan.arn}",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
    depends_on = [
   aws_kms_key.exampleKey
  ]
}
###################################################
#CodeBuild security IAM policy
###################################################
resource "aws_iam_policy" "CodeBuildBasePolicy-Security_Check" {
  description = "Policy used in trust relationship with CodeBuild"
  name        = var.security_check_policy_name
  path        = "/service-role/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:*",
          ]
          Effect = "Allow"
          "Resource" = [
            "arn:aws:s3::*:*pipeline*/*",
          ]
        },
        {
          Action = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages",
          ]
          Effect = "Allow"
          "Resource" = [
            "${aws_codebuild_report_group.sec_check.arn}",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags     = {}
  tags_all = {}
    depends_on = [
    aws_kms_key.exampleKey
  ]
}
###################################################
#CodePipeline IAM role policy attach
###################################################
resource "aws_iam_role_policy_attachment" "example-tf-Pipeline__AWSCodePipelineServiceRole--example-tf-Pipeline" {
  policy_arn = aws_iam_policy.example-tf-Pipeline.arn
  role       = aws_iam_role.example-tf-Pipeline.name
}
###################################################
#CodeBuild security IAM role policy attach
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-Security-Check-service-role__CodeBuildBasePolicy-Security_Check-" {
  policy_arn = aws_iam_policy.CodeBuildBasePolicy-Security_Check.arn
  role       = aws_iam_role.codebuild-Security-Check-service-role.name
}
###################################################
#CodeBuild tf apply IAM role policy attach Admin
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-TerraformCommit-service-role__AdministratorAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.codebuild-TerraformCommit-service-role.name
}
###################################################
#CodeBuild tf apply IAM role policy attach Base
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-TerraformCommit-service-role__CodeBuildBasePolicy-TerraformApply2-" {
  policy_arn = aws_iam_policy.CodeBuildBasePolicy-TerraformApply.arn
  role       = aws_iam_role.codebuild-TerraformCommit-service-role.name
}
###################################################
#CodeBuild tf plan IAM role policy attach Admin
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-TerraformPlan-service-role__AdministratorAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.codebuild-TerraformPlan-service-role.name
}
###################################################
#CodeBuild tf plan IAM role policy attach s3 full
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-TerraformPlan-service-role__AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.codebuild-TerraformPlan-service-role.id
}
###################################################
#CodeBuild tf plan IAM role policy attach Base
###################################################
resource "aws_iam_role_policy_attachment" "codebuild-TerraformPlan-service-role__CodeBuildBasePolicy-TerraformPlan-" {
  policy_arn = aws_iam_policy.CodeBuildBasePolicy-TerraformPlan.arn
  role       = aws_iam_role.codebuild-TerraformPlan-service-role.id
}
## test security check