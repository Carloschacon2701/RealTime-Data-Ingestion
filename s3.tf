

##################
# Raw Ingestion Bucket
##################
resource "aws_s3_bucket" "stream_raw_to_s3" {
  bucket = "streaming-raw-data-2343242"
  region = "us-east-1"
}
