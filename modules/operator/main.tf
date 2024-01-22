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

# Deploy node sensor if var.sensor_type = FalconNodeSensor
resource "kubectl_manifest" "falcon_node_sensor" {
  count     = var.sensor_type == "FalconNodeSensor" ? 1 : 0
  yaml_body = <<-YAML
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
    YAML
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}

# Deploy container sensor if var.sensor_type = FalconContainer
resource "kubectl_manifest" "falcon_container_sensor" {
  count     = var.sensor_type == "FalconContainer" ? 1 : 0
  yaml_body = <<-YAML
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
    YAML
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}

# # Deploy admission controller if var.falcon_admission = true
resource "kubectl_manifest" "falcon_admission_controller" {
  count     = var.falcon_admission ? 1 : 0
  yaml_body = <<-YAML
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
    YAML
  depends_on = [
    kubectl_manifest.falcon_operator
  ]
}
