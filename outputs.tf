output "kinesis_stream_name" {
  description = "Name of the Kinesis data stream that ingests raw user transactions."
  value       = aws_kinesis_stream.this.name
}

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis data stream for downstream integrations."
  value       = aws_kinesis_stream.this.arn
}

output "firehose_delivery_stream_name" {
  description = "Name of the Kinesis Data Firehose delivery stream pushing records into S3."
  value       = aws_kinesis_firehose_delivery_stream.stream_raw_to_s3.name
}

output "firehose_delivery_stream_arn" {
  description = "ARN of the Kinesis Data Firehose delivery stream for monitoring and IAM usage."
  value       = aws_kinesis_firehose_delivery_stream.stream_raw_to_s3.arn
}

output "raw_data_bucket_name" {
  description = "Name of the S3 bucket storing the raw ingested data."
  value       = aws_s3_bucket.stream_raw_to_s3.bucket
}

output "raw_data_bucket_arn" {
  description = "ARN of the S3 bucket used for raw data storage."
  value       = aws_s3_bucket.stream_raw_to_s3.arn
}

output "firehose_execution_role_arn" {
  description = "ARN of the IAM role assumed by Kinesis Data Firehose."
  value       = aws_iam_role.stream_raw_to_s3.arn
}

