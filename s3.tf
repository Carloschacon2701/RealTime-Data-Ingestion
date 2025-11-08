

resource "aws_s3_bucket" "stream_raw_to_s3" {
  bucket              = "streaming-raw-data-2343242"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-east-1"
}
