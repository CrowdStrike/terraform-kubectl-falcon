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
  description = "Cloud region of the Falcon platform."
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
  description = "Customer ID (CID) of the Falcon platform."
}
