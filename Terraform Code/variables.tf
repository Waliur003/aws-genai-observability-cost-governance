//Declare input variable to define the primary AWS deployment region
variable "aws_region" {
  description = "Target AWS Region for observability and governance infrastructure"
  type        = string
  default     = "us-east-1"
}


//Declare input variable to define the environment deployment tier
variable "environment" {
  description = "Execution environment identifier"
  type        = string
  default     = "production"
}


//Declare input variable to specify the primary engineering email address for alert delivery
variable "alert_email" {
  description = "Primary engineering email endpoint for SNS notifications"
  type        = string
  default     = "waliurrahmansun003@gmail.com"
}


//Declare input variable to specify the maximum monthly spending budget limit in USD
variable "monthly_budget_amount" {
  description = "Monthly spending ceiling limit in USD"
  type        = string
  default     = "10.0"
}


//Declare input variable to define the absolute spend impact threshold for ML cost anomalies
variable "anomaly_threshold_amount" {
  description = "Absolute dollar impact threshold to trigger cost anomaly alerts"
  type        = number
  default     = 2.0
}