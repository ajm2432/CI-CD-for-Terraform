#######################################
#GitHub Repo Connection
#######################################
resource "aws_codestarconnections_connection" "example-tf" {
  name          = "${var.connection_name}"
  provider_type = "GitHub"
}
#######################################
#example-tf-pipeline
#######################################
resource "aws_codepipeline" "example-tf-pipeline" {
  name             = "${var.pipeline_name}"
  role_arn         = var.example-tf-Pipeline-role
  tags             = {}
  tags_all         = {}

  artifact_store {
    location = var.artifact_location
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "main"
        "FullRepositoryId"     = "${var.full_repo_name}"
        "ConnectionArn"        = aws_codestarconnections_connection.example-tf.arn
        "OutputArtifactFormat" = "CODE_ZIP"
      }
      input_artifacts = []
      name            = "Source"
      namespace       = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      region    = "${var.region}"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "TerraformPlan"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name      = "Build"
      namespace = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = "${var.region}"
      run_order = 2
      version   = "1"
    }
    action {
      category = "Build"
      configuration = {
        "ProjectName" = "Security_Check"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name             = "Security_Check"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "${var.region}"
      run_order        = 3
      version          = "1"
    }
  }
    stage {
    name = "Approval"

    action {
      category = "Approval"
      configuration = {
        "CustomData"         = "Please Approve the terraform changes"
      }
      input_artifacts  = []
      name             = "DevOps-Approval"
      output_artifacts = []
      owner            = "AWS"
      provider         = "Manual"
      region           = "${var.region}"
      run_order        = 1
      version          = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "TerraformApply2"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "TerraformApply"
      output_artifacts = [
        "ApplyArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = "${var.region}"
      run_order = 1
      version   = "1"
    }
  }
}
