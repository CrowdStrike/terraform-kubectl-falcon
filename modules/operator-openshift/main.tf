# Create Namespace
resource "kubectl_manifest" "os_operator_project" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: falcon-operator
    YAML
}

# Create Operator Group
resource "kubectl_manifest" "os_operator_group" {
  yaml_body = <<-YAML
    apiVersion: operators.coreos.com/v1
    kind: OperatorGroup
    metadata:
      name: falcon-operator
      namespace: falcon-operator
    YAML
  depends_on = [ 
    kubectl_manifest.os_operator_project 
  ]
}

# Create Operator Subscription
resource "kubectl_manifest" "os_operator_subscription" {
  yaml_body = <<-YAML
    apiVersion: operators.coreos.com/v1alpha1
    kind: Subscription
    metadata:
      name: falcon-operator
      namespace: falcon-operator
    spec:
      channel: certified-0.9
      name: falcon-operator-rhmp
      source: redhat-marketplace
      sourceNamespace: openshift-marketplace
    YAML
  depends_on = [ 
    kubectl_manifest.os_operator_group 
  ]
}

# Deploy node sensor if var.sensor_type = FalconNodeSensor
resource "kubectl_manifest" "os_falcon_node_sensor" {
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
    YAML
  depends_on = [
    kubectl_manifest.os_operator_subscription
  ]
}

# Deploy admission controller if var.falcon_admission = true
resource "kubectl_manifest" "os_falcon_admission_controller" {
  count     = var.falcon_admission == true ? 1 : 0
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
    kubectl_manifest.os_operator_subscription
  ]
}
