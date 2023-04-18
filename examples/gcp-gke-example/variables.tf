variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
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

variable "cloud" {
  type        = string
  description = "Falcon Cloud Region to use."

  validation {
    condition     = contains(["us-1", "us-2", "eu-1"], var.cloud)
    error_message = "Cloud must be one of us-1, us-2 or eu-1."
  }
}

variable "sensor_type" {
  type        = string
  default     = "FalconNodeSensor"
  description = "Falcon sensor type: FalconNodeSensor or FalconContainer."

  validation {
    condition     = contains(["FalconNodeSensor", "FalconContainer"], var.sensor_type)
    error_message = "Sensor type must be FalconNodeSensor or FalconContainer."
  }
}

variable "operator_version" {
  description = "Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo."
  type        = string
  default     = "v0.7.2"
}

# Allowed Values: UBUNTU_CONTAINERD or COS_CONTAINERD
# If you choose COS_CONTAINERD, sensor_type must = FalconContainer
variable "image_type" {
  type        = string
  default     = "UBUNTU_CONTAINERD"
  description = "Operating system to use for the GKE nodes. Allowed Values: UBUNTU_CONTAINERD or COS_CONTAINERD"

  validation {
    condition     = contains(["UBUNTU_CONTAINERD", "COS_CONTAINERD"], var.image_type)
    error_message = "image_type must be UBUNTU_CONTAINERD or COS_CONTAINERD."
  }
}
