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

variable "environment" {
  description = "Environment or 'Alias' tag"
  type        = string
  default     = "tf_module"
}

variable "operator_version" {
  description = "Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo."
  type        = string
  default     = "v0.9.1"
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
  type        = bool
  description = "Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster."
  default     = true
}

variable "cleanup" {
  type        = bool
  description = "Whether to cleanup resources on destroy."
  default     = true
}

variable "platform" {
  description = "Specify whether your cluster is managed by kubernetes or openshift."
  type        = string
  default     = "kubernetes"
  
  validation {
    condition     = contains(["kubernetes", "openshift"], var.platform)
    error_message = "Platform must be kubernetes or openshift."
  }
}

variable "node_manifest_path" {
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
