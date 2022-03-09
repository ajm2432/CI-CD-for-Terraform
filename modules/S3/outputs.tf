output "log_bucket" {
  value = aws_s3_bucket.log_bucket.arn
}
output "log_bucket_name" {
  value = aws_s3_bucket.log_bucket.id
}
output "aws_pipeline_bucket" {
  value = aws_s3_bucket.pipelinebucket.id
}