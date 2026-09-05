//Declare AWS Budgets resource to enforce a monthly spending limit with actual and forecasted notifications
resource "aws_budgets_budget" "monthly_budget" {
  name              = "genai-monthly-budget"
  budget_type       = "COST"
  limit_amount      = var.monthly_budget_amount
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2026-01-01_00:00"

  # Threshold notification triggered when actual spend reaches 80% ($8.00)
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = [aws_sns_topic.genai_alerts.arn]
  }

  # Threshold notification triggered when forecasted spend reaches 100% ($10.00)
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_sns_topic_arns  = [aws_sns_topic.genai_alerts.arn]
  }

  depends_on = [aws_sns_topic_policy.sns_publish_policy]
}