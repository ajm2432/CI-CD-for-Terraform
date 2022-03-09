
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
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin2"
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