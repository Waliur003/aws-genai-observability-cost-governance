//Declare Amazon SNS topic resource to serve as the centralized platform alerting hub
resource "aws_sns_topic" "genai_alerts" {
  name         = "genai-alerts-topic"
  display_name = "GenAI Platform Alerting Hub"
}


//Declare Amazon SNS subscription resource to route urgent alerts to engineering email
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.genai_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}


//Declare Amazon SNS topic policy allowing CloudWatch Alarms, AWS Budgets, and Cost Anomaly services to publish notifications
resource "aws_sns_topic_policy" "sns_publish_policy" {
  arn = aws_sns_topic.genai_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudWatchAlarms"
        Effect    = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.genai_alerts.arn
      },
      {
        Sid       = "AllowBudgetsAlerts"
        Effect    = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.genai_alerts.arn
      },
      {
        Sid       = "AllowCostAnomalyAlerts"
        Effect    = "Allow"
        Principal = {
          Service = "costalerts.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.genai_alerts.arn
      }
    ]
  })
}