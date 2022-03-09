###################################################
#ec2 Key-pair
###################################################
resource "aws_key_pair" "deployer" {
  key_name   = "test-keys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCq9QcPKvSu+A0fSsiZbKPY3THELPCDPTRRsCPoSZGb7II32n+f94t9Per0xl47hq+fiwiV0wmC9dZdtgipFCvHt2dDRcEFkHwln3mGaqlh8EkI6RO5wVZDIfvFI1dAAT/C8LBjiUkAAGhSG1wnbjuI6M1PiBHg51uLEfV+siGLZV9ZCasMZwSWeU+w2b8x/HfNWIrQsTM5hUo2Pmj+ONdrC8kCtdbLGobPGh/O+nKfBlAYu/o2+NR1QdFoGCz7eECm1jFixiUd7mnJDl3jrTF9YQYoqEsw//kBc2eau3WXpDGSf+XPvjolvy3wSwrt5MbG+RY9ntQs04sEJrxvN3Vf root@SEA-1801004923"
}
###################################################
#KMS Key
###################################################
resource "aws_kms_key" "exampleKey" {
  description             = "exampleKey"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode(
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.codebuild-TerraformCommit-service-role.arn}",
                    "${aws_iam_role.codebuild-TerraformPlan-service-role.arn}",
                    "${aws_iam_role.codebuild-Security-Check-service-role.arn}",
                    "${aws_iam_role.example-tf-Pipeline.arn}"
                ],
                "Service": ["delivery.logs.amazonaws.com","logs.${var.region}.amazonaws.com"]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }, 
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.codebuild-TerraformCommit-service-role.arn}",
                    "${aws_iam_role.codebuild-TerraformPlan-service-role.arn}",
                    "${aws_iam_role.codebuild-Security-Check-service-role.arn}",
                    "${aws_iam_role.example-tf-Pipeline.arn}",
                ],
                "Service": ["delivery.logs.amazonaws.com"]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
  )
  depends_on = [
    aws_iam_role.codebuild-Security-Check-service-role, aws_iam_role.codebuild-TerraformCommit-service-role, aws_iam_role.codebuild-TerraformPlan-service-role,aws_iam_role.example-tf-Pipeline
  ]
}
resource "aws_kms_alias" "main" {
  name          = "alias/main"
  target_key_id = aws_kms_key.exampleKey.key_id
}