
resource "null_resource" "remove_container_sensor" {
  count = var.cleanup && var.sensor_type == "FalconContainer" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconcontainers.falcon.crowdstrike.com --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_node_sensor" {
  count = var.cleanup && var.sensor_type == "FalconNodeSensor" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconnodesensors --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_admission_controller" {
  count = var.cleanup && var.falcon_admission ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconadmissions --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_iar" {
  count = var.cleanup && var.iar ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconimageanalyzer --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}
