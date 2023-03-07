variable "cloud" {
  type        = string
  default     = "us-1"
  description = "Cloud region of the Falcon platform. Required to install KPA."
}

variable "aws_secret_name" {
  type        = string
  default     = "crowdstrike_falcon_addon/secrets"
  description = "The secret name value to use when pulling the falcon credentials from AWS Secrets Manager"
}

variable "aws_secret_version_stage" {
  type        = string
  default     = "AWSCURRENT"
  description = "The secret version value to use when pulling the falcon credentials from AWS Secrets Manager"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "The region to build in."
}
