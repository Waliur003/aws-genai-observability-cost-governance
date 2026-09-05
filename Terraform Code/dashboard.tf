//Declare CloudWatch dashboard resource creating a unified command center for metrics and log insights
resource "aws_cloudwatch_dashboard" "genai_dashboard" {
  dashboard_name = "GenAI-Global-Observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 8
        height = 4
        properties = {
          metrics = [
            ["GenAIRouter", "ModelInvocations", "ModelId", "amazon.nova-lite-v1:0", { stat = "Sum", period = 60 }],
            ["...", "amazon.nova-micro-v1:0", { stat = "Sum", period = 60 }]
          ]
          view    = "singleValue"
          region  = var.aws_region
          title   = "Total Model Invocations"
          stacked = false
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 0
        width  = 8
        height = 4
        properties = {
          metrics = [
            ["GenAIRouter", "FallbackCount", "FailedPrimary", "amazon.nova-micro-v1:0", { stat = "Sum", period = 60 }]
          ]
          view    = "singleValue"
          region  = var.aws_region
          title   = "Total Circuit-Breaker Fallbacks"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 0
        width  = 8
        height = 6
        properties = {
          metrics = [
            ["GenAIRouter", "ModelInvocations", "ModelId", "amazon.nova-micro-v1:0", { label = "Fast Tier (Nova Micro)", stat = "Sum", period = 60 }],
            ["...", "amazon.nova-lite-v1:0", { label = "Reasoning Tier (Nova Lite)", stat = "Sum", period = 60 }]
          ]
          view    = "timeSeries"
          region  = var.aws_region
          title   = "Traffic Volume by Model Tier"
          period  = 60
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 4
        width  = 16
        height = 6
        properties = {
          metrics = [
            ["GenAIRouter", "InvocationLatency", "ModelId", "amazon.nova-micro-v1:0", { label = "Latency Nova Micro (ms)", stat = "Average", period = 60 }],
            ["...", "amazon.nova-lite-v1:0", { label = "Latency Nova Lite (ms)", stat = "Average", period = 60 }]
          ]
          view    = "timeSeries"
          region  = var.aws_region
          title   = "Inference Latency by Model Tier (ms)"
          period  = 60
          yAxis   = {
            left = {
              label = "Milliseconds"
            }
          }
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 10
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.router_logs.arn}' | fields @timestamp, @message | filter @message like /WARN/ or @message like /ERROR/ or @message like /fallback/ | sort @timestamp desc | limit 20"
          region  = var.aws_region
          title   = "Gateway Logs & Failover Errors"
          view    = "table"
        }
      }
    ]
  })
}