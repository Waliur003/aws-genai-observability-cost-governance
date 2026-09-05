//Declare output variable to expose the centralized alerting SNS topic ARN
output "sns_topic_arn" {
  description = "ARN of the centralized alerting SNS topic"
  value       = aws_sns_topic.genai_alerts.arn
}


//Declare output variable to expose the deployed CloudWatch dashboard name
output "cloudwatch_dashboard_name" {
  description = "Name of the global observability dashboard"
  value       = aws_cloudwatch_dashboard.genai_dashboard.dashboard_name
}


//Declare output variable to expose the ARN of the circuit breaker fallback alarm
output "fallback_alarm_arn" {
  description = "ARN of the circuit breaker fallback alarm"
  value       = aws_cloudwatch_metric_alarm.fallback_alarm.arn
}


//Declare output variable to expose the ARN of the model latency degradation alarm
output "latency_alarm_arn" {
  description = "ARN of the model latency degradation alarm"
  value       = aws_cloudwatch_metric_alarm.latency_alarm.arn
}


//Declare output variable to expose the name of the configured AWS Monthly Budget
output "monthly_budget_name" {
  description = "Name of the configured AWS Monthly Budget"
  value       = aws_budgets_budget.monthly_budget.name
}


//Declare output variable to expose the ARN of the AWS Cost Anomaly Monitor
output "anomaly_monitor_arn" {
  description = "ARN of the AWS Cost Anomaly Monitor"
  value       = aws_ce_anomaly_monitor.service_monitor.arn
}