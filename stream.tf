

resource "aws_kinesis_stream" "this" {
  encryption_type           = "NONE"
  enforce_consumer_deletion = null
  kms_key_id                = null
  max_record_size_in_kib    = 1024
  name                      = "user-transaction-stream"
  region                    = "us-east-1"
  retention_period          = 24
  shard_count               = 0
  shard_level_metrics       = []
  tags                      = {}
  tags_all                  = {}
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "stream_raw_to_s3" {
  destination    = "extended_s3"
  destination_id = "destinationId-000000000001"
  name           = "StreamRawToS3"
  region         = "us-east-1"
  tags           = {}
  tags_all       = {}
  version_id     = "1"
  extended_s3_configuration {
    bucket_arn          = aws_s3_bucket.stream_raw_to_s3.arn
    buffering_interval  = 60
    buffering_size      = 64
    compression_format  = "GZIP"
    custom_time_zone    = "UTC"
    error_output_prefix = null
    file_extension      = null
    kms_key_arn         = null
    prefix              = "raw/"
    role_arn            = aws_iam_role.stream_raw_to_s3.arn
    s3_backup_mode      = "Disabled"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/StreamRawToS3"
      log_stream_name = "DestinationDelivery"
    }
    processing_configuration {
      enabled = false
    }
  }
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.this.arn
    role_arn           = aws_iam_role.stream_raw_to_s3.arn
  }
  depends_on = [aws_kinesis_stream.this, aws_iam_role.stream_raw_to_s3, aws_iam_policy.stream_raw_to_s3, aws_s3_bucket.stream_raw_to_s3]
}

