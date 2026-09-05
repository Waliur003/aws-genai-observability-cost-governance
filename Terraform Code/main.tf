//Declare Terraform configuration block specifying core version requirements and required AWS provider
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


//Declare AWS provider configuration to target specified region and apply global default tags across all Project 6 resources
provider "aws" {
  region = var.aws_region

  # Global default resource tags applied to every provisioned AWS resource
  default_tags {
    tags = {
      Project     = "GenAI-Observability-FinOps"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}


//Declare CloudWatch log group resource to act as an active placeholder for router Lambda execution logs
resource "aws_cloudwatch_log_group" "router_logs" {
  name              = "/aws/lambda/genai-router-lambda"
  retention_in_days = 14
}