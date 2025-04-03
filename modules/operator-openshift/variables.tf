variable "client_id" {
  type        = string
  description = "Falcon API Client ID"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Falcon API Client Secret"
  sensitive   = true
}

variable "cloud" {
  type        = string
  description = "Falcon Cloud Region"
  default     = "us-1"

  validation {
    condition     = contains(["us-1", "us-2", "eu-1", "us-gov-1"], var.cloud)
    error_message = "Falcon Cloud Region must be us-1, us-2, eu-1 or us-gov-1"
  }
}

variable "environment" {
  description = "Environment or 'Alias' tag"
  type        = string
  default     = "tf_module"
}

# variable "operator_version" {
#   description = "Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo."
#   type        = string
#   default     = "v0.9.1"
# }

variable "falcon_admission" {
  description = "Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster."
  type        = bool
  default     = true
}

variable "iar" {
  description = "Whether to deploy the Falcon Image Analyzer Custom Resource (CR) to the cluster."
  type        = bool
  default     = false
}

variable "cleanup" {
  type        = bool
  description = "Whether to cleanup resources on destroy."
  default     = true
}

variable "node_sensor_mode" {
  description = "Falcon Node Sensor mode: 'kernel' or 'bpf'."
  type        = string
  default     = "bpf"

  validation {
    condition     = contains(["kernel", "bpf"], var.node_sensor_mode)
    error_message = "Falcon Node Sensor must be kernel or bpf."
  }
}

variable "node_sensor_manifest_path" {
  type = string
  default = "default"
}

variable "container_sensor_manifest_path" {
  type = string
  default = "default"
}

variable "admission_controller_manifest_path" {
  type = string
  default = "default"
}

variable "iar_manifest_path" {
  type = string
  default = "default"
}
