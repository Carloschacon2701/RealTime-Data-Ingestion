data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "this" {
  application_failure_feedback_role_arn    = null
  application_success_feedback_role_arn    = null
  application_success_feedback_sample_rate = 0
  archive_policy                           = null
  content_based_deduplication              = false
  delivery_policy                          = null
  display_name                             = "Abnormal detected topic"
  fifo_throughput_scope                    = null
  fifo_topic                               = false
  firehose_failure_feedback_role_arn       = null
  firehose_success_feedback_role_arn       = null
  firehose_success_feedback_sample_rate    = 0
  http_failure_feedback_role_arn           = null
  http_success_feedback_role_arn           = null
  http_success_feedback_sample_rate        = 0
  kms_master_key_id                        = null
  lambda_failure_feedback_role_arn         = null
  lambda_success_feedback_role_arn         = null
  lambda_success_feedback_sample_rate      = 0
  name                                     = "AbnormalNotification"
  name_prefix                              = null
  region                                   = "us-east-1"
  sqs_failure_feedback_role_arn            = null
  sqs_success_feedback_role_arn            = null
  sqs_success_feedback_sample_rate         = 0
  tags                                     = {}
  tags_all                                 = {}
  tracing_config                           = "PassThrough"
}

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

resource "aws_sns_topic_policy" "this" {
  arn        = aws_sns_topic.this.arn
  policy     = data.aws_iam_policy_document.sns_topic.json
  depends_on = [aws_sns_topic.this]
}

resource "aws_sns_topic_subscription" "this" {
  confirmation_timeout_in_minutes = null
  delivery_policy                 = null
  endpoint                        = "test_lambda@yopmail.com"
  endpoint_auto_confirms          = null
  filter_policy                   = null
  filter_policy_scope             = null
  protocol                        = "email"
  raw_message_delivery            = false
  redrive_policy                  = null
  region                          = "us-east-1"
  replay_policy                   = null
  subscription_role_arn           = null
  topic_arn                       = aws_sns_topic.this.arn

  depends_on = [aws_sns_topic.this]
}

