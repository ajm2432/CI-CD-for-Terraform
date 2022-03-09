###################################################
#CodeBuild Security check
###################################################
data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}
resource "aws_codebuild_project" "Security_Check" {
  badge_enabled          = false
  build_timeout          = 60
  encryption_key         = data.aws_kms_alias.s3.arn
  name                   = "Security_Check"
  queued_timeout         = 480
  service_role           = var.codebuild-Security-Check-role
  source_version         = "refs/heads/main"
  tags                   = {}
  tags_all               = {}

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
     cloudwatch_logs {
      status = "DISABLED"
    } 

    s3_logs {
      encryption_disabled = false
      status              ="ENABLED"
      location            = "${var.artifact_location}/build-logs"
    }
  }

  source {
    buildspec           = <<EOT
            version: 0.2
            
            phases:
              install:
               runtime-versions:
                   python: latest
               commands:
                - yum install -y yum-utils
                - yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                - yum -y install terraform
                - pip3 install checkov
              build:
                commands:
                   - checkov --directory . 
            
                   
              post_build:
                commands:
                   - echo "check the TF plan, please"
        EOT
    git_clone_depth     = 1
    location            = "${var.git_hub_url}"
    report_build_status = false
    type                = "GITHUB"
  }
}
###################################################
#CodeBuild tf plan
###################################################
resource "aws_codebuild_project" "TerraformPlan" {
  badge_enabled          = false
  build_timeout          = 60
  encryption_key         = data.aws_kms_alias.s3.arn
  name                   = "TerraformPlan"
  queued_timeout         = 480
  service_role           = var.codebuild-tf-plan-role
  source_version         = "refs/heads/main"
  tags                   = {}
  tags_all               = {}

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
     cloudwatch_logs {
      status = "DISABLED"
    } 

    s3_logs {
      encryption_disabled = false
      status              ="ENABLED"
      location            = "${var.artifact_location}/build-logs"
    }
  }

  source {
    buildspec           = <<EOT
            version: 0.2
            
            phases:
              install:
                commands:
                   - yum install -y yum-utils
                   - yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                   - yum -y install terraform
              build:
                commands:
                   - terraform init
                   - terraform plan
                   
              post_build:
                commands:
                   - echo "check the TF plan, please"
            #reports:
              #report-name-or-arn:
                #files:
                  # - location
                  # - location
                #base-directory: location
                #discard-paths: yes
                #file-format: JunitXml | CucumberJson
                # - location
              #name: $(date +%Y-%m-%d)
              #discard-paths: yes
              #base-directory: location
            #cache:
              #paths:
                # - paths
        EOT
    git_clone_depth     = 1
    location            = "${var.git_hub_url}"
    report_build_status = false
    type                = "GITHUB"
  }
}
###################################################
#CodeBuild tf apply2 plan
###################################################
resource "aws_codebuild_project" "TerraformApply2" {
  badge_enabled          = false
  build_timeout          = 60
  encryption_key         = data.aws_kms_alias.s3.arn
  name                   = "TerraformApply2"
  queued_timeout         = 480
  service_role           = var.codebuild-TerraformCommit-role
  source_version         = "refs/heads/main"
  tags                   = {}
  tags_all               = {}

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
     cloudwatch_logs {
      status = "DISABLED"
    } 

    s3_logs {
      encryption_disabled = false
      status              ="ENABLED"
      location            = "${var.artifact_location}/build-logs"
    }
  }

  source {
    buildspec           = <<EOT
            version: 0.2
            
            phases:
              install:
                commands:
                   - yum install -y yum-utils
                   - yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                   - yum -y install terraform
              build:
                commands:
                   - terraform init
                   - terraform apply -auto-approve
                   
              post_build:
                commands:
                   - echo "done"
        EOT
    git_clone_depth     = 1
    location            = "${var.git_hub_url}"
    report_build_status = false
    type                = "GITHUB"
  }
}