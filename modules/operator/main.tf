data "http" "falcon_operator" {
  url = "https://raw.githubusercontent.com/CrowdStrike/falcon-operator/1dd6ea996d65d4d4e6004d21ce7f5ad62a44cb35/deploy/falcon-operator.yaml"
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
      name: falcon-node-sensor
    spec:
      falcon_api:
        client_id: ${var.client_id}
        client_secret: ${var.client_secret}
        cloud_region: autodiscover
      node: {}
      falcon:
        tags:
        - ${var.environment}
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
