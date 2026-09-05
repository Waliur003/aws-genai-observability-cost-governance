//Declare CloudWatch metric alarm resource triggering when circuit-breaker fallbacks reach or exceed two occurrences within one minute
resource "aws_cloudwatch_metric_alarm" "fallback_alarm" {
  alarm_name          = "genai-high-fallback-rate-alarm"
  alarm_description   = "Triggers when 2 or more automated circuit-breaker fallbacks occur within 1 minute."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FallbackCount"
  namespace           = "GenAIRouter"
  period              = 60
  statistic           = "Sum"
  threshold           = 2
  treat_missing_data  = "missing"

  dimensions = {
    FailedPrimary = "amazon.nova-micro-v1:0"
  }

  alarm_actions = [aws_sns_topic.genai_alerts.arn]
}


//Declare CloudWatch metric alarm resource triggering when average model inference latency exceeds three seconds within one minute
resource "aws_cloudwatch_metric_alarm" "latency_alarm" {
  alarm_name          = "genai-high-latency-alarm"
  alarm_description   = "Triggers when average model inference latency exceeds 3 seconds."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "InvocationLatency"
  namespace           = "GenAIRouter"
  period              = 60
  statistic           = "Average"
  threshold           = 3000
  treat_missing_data  = "missing"

  dimensions = {
    ModelId = "amazon.nova-lite-v1:0"
  }

  alarm_actions = [aws_sns_topic.genai_alerts.arn]
}