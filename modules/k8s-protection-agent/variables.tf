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

variable "cluster_name" {
  type        = string
  description = "Your Cluster Name"
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

variable "cloud" {
  type        = string
  description = "Falcon Cloud Region"

  validation {
    condition     = contains(["us-1", "us-2", "eu-1", "us-gov-1"], var.cloud)
    error_message = "Falcon Cloud Region must be one of us-1, us-2, eu-1 or us-gov-1"
  }
}
