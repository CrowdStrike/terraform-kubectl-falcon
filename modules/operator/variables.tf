variable "sensor_type" {
  type        = string
  default     = "FalconNodeSensor"
  description = "Falcon sensor type: FalconNodeSensor or FalconContainer."

  validation {
    condition     = contains(["FalconNodeSensor", "FalconContainer"], var.sensor_type)
    error_message = "Sensor type must be FalconNodeSensor or FalconContainer."
  }
}

variable "client_id" {
  type        = string
  description = "Falcon API Client Id"
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
    condition     = contains(["us-1", "us-2", "eu-1", "us-gov-1", "us-gov-2"], var.cloud)
    error_message = "Falcon Cloud Region must be us-1, us-2, eu-1, us-gov-1 or us-gov-2"
  }
}

variable "cid" {
  type        = string
  description = "Customer ID (CID) of the Falcon platform. Required when using us-gov-2 cloud region."
  default     = ""
}

variable "environment" {
  description = "Environment or 'Alias' tag"
  type        = string
  default     = "tf_module"
}

variable "operator_version" {
  description = "Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo."
  type        = string
  default     = "v1.4.0"
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
