variable "cluster_name" {
  type        = string
  description = "The name of the AWS EKS cluster to deploy to."
}

variable "region" {
  type        = string
  description = "The AWS region the EKS cluster exists in."
}

variable "cloud" {
  type        = string
  default     = "us-1"
  description = "Falcon Cloud Region"

  validation {
    condition     = contains(["us-1", "us-2", "eu-1", "us-gov-1", "us-gov-2"], var.cloud)
    error_message = "Falcon Cloud Region must be us-1, us-2, eu-1, us-gov-1 or us-gov-2"
  }
}

variable "client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Id"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}

variable "docker_api_token" {
  type        = string
  sensitive   = true
  description = "Falcon Docker API Token"
}

variable "cid" {
  type        = string
  description = "Customer ID (CID) of the Falcon platform. Required when using us-gov-2 cloud region."
  default     = ""
}
