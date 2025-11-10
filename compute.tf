data "archive_file" "example" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "this" {
  function_name = "LambdaFanoutFunction"
  filename      = data.archive_file.example.output_path
  handler       = "index.handler"
  role          = aws_iam_role.lambda_fanout_function.arn
  runtime       = "python3.8"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.this.arn
      TABLE_NAME    = aws_dynamodb_table.this.name
    }
  }

}
