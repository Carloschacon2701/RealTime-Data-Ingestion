
##################
# Abnormality Detection Table
##################
resource "aws_dynamodb_table" "this" {
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "transactionId"
  name           = "AbnormalityTable"
  range_key      = "createdAt"
  read_capacity  = 0
  write_capacity = 0
  attribute {
    name = "createdAt"
    type = "S"
  }
  attribute {
    name = "transactionId"
    type = "S"
  }

}
