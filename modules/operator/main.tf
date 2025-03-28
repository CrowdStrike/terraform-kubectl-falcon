data "http" "falcon_operator" {
  url = "https://raw.githubusercontent.com/CrowdStrike/falcon-operator/${var.operator_version}/deploy/falcon-operator.yaml"
}

data "kubectl_file_documents" "docs" {
  content = data.http.falcon_operator.response_body
}

resource "kubectl_manifest" "falcon_operator" {
  for_each  = data.kubectl_file_documents.docs.manifests
  yaml_body = each.value
}

# Set default manifests
locals {
  default_node_sensor_manifest = <<EOT
  apiVersion: falcon.crowdstrike.com/v1alpha1
  kind: FalconNodeSensor
  metadata:
    labels:
      crowdstrike.com/component: sample
      crowdstrike.com/created-by: falcon-operator
      crowdstrike.com/instance: falcon-node-sensor
      crowdstrike.com/managed-by: kustomize
      crowdstrike.com/name: falconnodesensor
      crowdstrike.com/part-of: Falcon
      crowdstrike.com/provider: crowdstrike
    name: falcon-node-sensor
    namespace: falcon-operator
  spec:
    falcon:
      tags:
      - daemonset
      - ${var.environment}
      trace: none
    falcon_api:
      client_id: ${var.client_id}
      client_secret: ${var.client_secret}
      cloud_region: autodiscover
    node:
      backend: ${var.node_sensor_mode}
  EOT
  default_container_sensor_manifest = <<EOT
  apiVersion: falcon.crowdstrike.com/v1alpha1
  kind: FalconContainer
  metadata:
    name: falcon-container-sensor
  spec:
    falcon_api:
      client_id: ${var.client_id}
      client_secret: ${var.client_secret}
      cloud_region: autodiscover
    registry:
      type: crowdstrike
    falcon:
      tags:
      - ${var.environment}
  EOT
  default_admission_controller_manifest = <<EOT
  apiVersion: falcon.crowdstrike.com/v1alpha1
  kind: FalconAdmission
  metadata:
    name: falcon-admission
  spec:
    falcon_api:
      client_id: ${var.client_id}
      client_secret: ${var.client_secret}
      cloud_region: autodiscover
    registry:
      type: crowdstrike
    falcon:
      tags:
      - ${var.environment}
  EOT
  default_iar_manifest = <<EOT
  apiVersion: falcon.crowdstrike.com/v1alpha1
  kind: FalconImageAnalyzer
  metadata:
    name: falcon-image-analyzer
  spec:
    falcon_api:
      client_id: ${var.client_id}
      client_secret: ${var.client_secret}
      cloud_region: ${var.cloud}
    registry:
      type: crowdstrike
    falcon:
      tags:
      - ${var.environment}
  EOT
}

# Get custom manifests if path != "Default"
data "local_file" "node_sensor_manifest" {
  count = var.node_sensor_manifest_path == "default" ? 0 : 1
  filename = var.node_sensor_manifest_path
}

data "local_file" "container_sensor_manifest" {
  count = var.container_sensor_manifest_path == "default" ? 0 : 1
  filename = var.container_sensor_manifest_path
}

data "local_file" "admission_controller_manifest" {
  count = var.admission_controller_manifest_path == "default" ? 0 : 1
  filename = var.admission_controller_manifest_path
}

data "local_file" "iar_manifest" {
  count = var.iar_manifest_path == "default" ? 0 : 1
  filename = var.iar_manifest_path
}

# Deploy node sensor if var.sensor_type = FalconNodeSensor
resource "kubectl_manifest" "falcon_node_sensor" {
  count     = var.sensor_type == "FalconNodeSensor" ? 1 : 0
  yaml_body = var.node_sensor_manifest_path == "default" ? local.default_node_sensor_manifest : data.local_file.node_sensor_manifest[0].content
  depends_on = [
    kubectl_manifest.falcon_operator, data.local_file.node_sensor_manifest
  ]
}

# Deploy container sensor if var.sensor_type = FalconContainer
resource "kubectl_manifest" "falcon_container_sensor" {
  count     = var.sensor_type == "FalconContainer" ? 1 : 0
  yaml_body = var.container_sensor_manifest_path == "default" ? local.default_container_sensor_manifest : data.local_file.container_sensor_manifest[0].content
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}

# Deploy admission controller if var.falcon_admission = true
resource "kubectl_manifest" "falcon_admission_controller" {
  count     = var.falcon_admission ? 1 : 0
  yaml_body = var.admission_controller_manifest_path == "default" ? local.default_admission_controller_manifest : data.local_file.admission_controller_manifest[0].content
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}

# Deploy admission controller if var.iar = true
resource "kubectl_manifest" "iar" {
  count     = var.iar ? 1 : 0
  yaml_body = var.iar_manifest_path == "default" ? local.default_iar_manifest : data.local_file.iar_manifest[0].content
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}
