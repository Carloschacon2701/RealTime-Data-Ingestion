
resource "aws_dynamodb_table" "this" {
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false
  hash_key                    = "transactionId"
  name                        = "AbnormalityTable"
  range_key                   = "createdAt"
  read_capacity               = 0
  region                      = "us-east-1"
  restore_date_time           = null
  restore_source_name         = null
  restore_source_table_arn    = null
  restore_to_latest_time      = null
  stream_enabled              = false
  stream_view_type            = null
  table_class                 = "STANDARD"
  tags                        = {}
  tags_all                    = {}
  write_capacity              = 0
  attribute {
    name = "createdAt"
    type = "S"
  }
  attribute {
    name = "transactionId"
    type = "S"
  }

  ttl {
    attribute_name = null
    enabled        = false
  }
}
