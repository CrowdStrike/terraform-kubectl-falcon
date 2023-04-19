variable "cloud" {
  type        = string
  default     = "us-1"
  description = "Cloud region of the Falcon platform. Required to install KPA."
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "The region to build in."
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
