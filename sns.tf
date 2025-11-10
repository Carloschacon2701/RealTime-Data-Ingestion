##################
# Caller Identity Lookup
##################
data "aws_caller_identity" "current" {}

##################
# Abnormal Detection Topic
##################
resource "aws_sns_topic" "this" {
  display_name   = "Abnormal detected topic"
  name           = "AbnormalNotification"
  tracing_config = "PassThrough"
}

##################
# SNS Topic Access Policy
##################
data "aws_iam_policy_document" "sns_topic" {
  statement {
    sid = "__default_statement_ID"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
    ]
    resources = [aws_sns_topic.this.arn]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

##################
# SNS Topic Policy Attachment
##################
resource "aws_sns_topic_policy" "this" {
  arn        = aws_sns_topic.this.arn
  policy     = data.aws_iam_policy_document.sns_topic.json
  depends_on = [aws_sns_topic.this]
}

##################
# SNS Email Subscription
##################
resource "aws_sns_topic_subscription" "this" {
  endpoint             = "test_lambda@yopmail.com"
  protocol             = "email"
  raw_message_delivery = false
  region               = "us-east-1"
  topic_arn            = aws_sns_topic.this.arn

  depends_on = [aws_sns_topic.this]
}

