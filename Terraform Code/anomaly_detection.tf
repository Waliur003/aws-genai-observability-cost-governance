//Declare AWS Cost Anomaly Monitor resource tracking dimensional service-level spend anomalies using machine learning
resource "aws_ce_anomaly_monitor" "service_monitor" {
  name              = "genai-services-anomaly-monitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}


//Declare AWS Cost Anomaly Subscription resource to route immediate notifications to SNS when spend impact meets threshold
resource "aws_ce_anomaly_subscription" "anomaly_subscription" {
  name      = "genai-anomaly-alert-subscription"
  frequency = "IMMEDIATE"

  monitor_arn_list = [
    aws_ce_anomaly_monitor.service_monitor.arn
  ]

  subscriber {
    type    = "SNS"
    address = aws_sns_topic.genai_alerts.arn
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      values        = [tostring(var.anomaly_threshold_amount)]
      match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }

  depends_on = [aws_sns_topic_policy.sns_publish_policy]
}