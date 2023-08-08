
resource "null_resource" "remove_container_sensor" {
  count = var.sensor_type == "FalconContainer" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconcontainers.falcon.crowdstrike.com --all"
    when = destroy
  }
  depends_on = [ kubectl_manifest.falcon_operator ]
}

resource "null_resource" "remove_node_sensor" {
  count = var.sensor_type == "FalconNodeSensor" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconnodesensors --all"
    when = destroy
  }
  depends_on = [ kubectl_manifest.falcon_operator ]
}
