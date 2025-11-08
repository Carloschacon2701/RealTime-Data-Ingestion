resource "aws_iam_role" "stream_raw_to_s3" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = "Allows Firehose to transform and deliver data to your destinations using CloudWatch Logs, Lambda, and S3 on your behalf."
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "FireHoseRole"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}

}

resource "aws_iam_policy" "stream_raw_to_s3" {
  description = null
  name        = "FireHoseS3StreamRawToS3Policy"
  name_prefix = null
  path        = "/"
  policy = jsonencode({
    Statement = [{
      Action   = ["kinesis:GetRecords", "kinesis:GetShardIterator", "kinesis:DescribeStream", "kinesis:ListShards"]
      Effect   = "Allow"
      Resource = aws_kinesis_stream.this.arn
      Sid      = "KinesisReadAccess"
      }, {
      Action   = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject"]
      Effect   = "Allow"
      Resource = [aws_s3_bucket.stream_raw_to_s3.arn, "${aws_s3_bucket.stream_raw_to_s3.arn}/*"]
      Sid      = "S3WriteAccess"
    }]
    Version = "2012-10-17"
  })
  tags     = {}
  tags_all = {}

  depends_on = [aws_kinesis_stream.this, aws_iam_role.stream_raw_to_s3, aws_s3_bucket.stream_raw_to_s3]
}



resource "aws_iam_role_policy_attachment" "stream_raw_to_s3" {
  policy_arn = aws_iam_policy.stream_raw_to_s3.arn
  role       = aws_iam_role.stream_raw_to_s3.name
}
