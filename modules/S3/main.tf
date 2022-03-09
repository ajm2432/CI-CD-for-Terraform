data "aws_caller_identity" "current" {}
locals {
  elb-id = "127311923021"
}
###################################################
#VPC Log Bucket Creation
###################################################
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  force_destroy = true
  versioning {
  enabled = true
  }
server_side_encryption_configuration {
   rule {
       apply_server_side_encryption_by_default {
       kms_master_key_id = "${var.kms_key}"
       sse_algorithm = "aws:kms"
       }
   }
}
}
resource "aws_s3_bucket_object" "this" {
  bucket = aws_s3_bucket.log_bucket.id
  key    = "image-log/"
  kms_key_id = var.kms_key

}
resource "aws_s3_bucket_object" "pipeline-log" {
  bucket = aws_s3_bucket.log_bucket.id
  key    = "pipeline-log/"
  kms_key_id = var.kms_key

}
###################################################
#VPC Log Bucket block public access
###################################################
resource "aws_s3_bucket_public_access_block" "logbucketeaccess" {
  bucket = aws_s3_bucket.log_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
###################################################
#VPC Log Bucket policy
###################################################
resource "aws_s3_bucket_policy" "allow_access_for_vpc_logs" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Id": "AWSLogDeliveryWrite20150319",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.log_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "540204466076",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.log_bucket.arn}",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "540204466076"
                },
            }
        }
    ]
}
  )
}

###################################################
#CodePipeline Bucket Creation
###################################################
resource "aws_s3_bucket" "pipelinebucket" {
  bucket = var.pipeline_bucket_name
  acl    = "private"
  force_destroy = true
versioning {
  enabled = true
  }
logging {
   target_bucket = aws_s3_bucket.log_bucket.id
   target_prefix = "pipeline-log/"
  }
server_side_encryption_configuration {
   rule {
       apply_server_side_encryption_by_default {
       kms_master_key_id = "${var.kms_key}"
       sse_algorithm = "aws:kms"
       }
   }
}
   }

###################################################
#CodePipeline Bucket block public access
###################################################
resource "aws_s3_bucket_public_access_block" "pipelineaccess" {
  bucket = aws_s3_bucket.pipelinebucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}