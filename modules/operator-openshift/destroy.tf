resource "null_resource" "os_remove_container_sensor" {
  count = var.sensor_type == "FalconContainer" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconadmissions falcon-sidecar-sensor"
    when    = destroy
  }
  depends_on = [kubectl_manifest.os_operator_subscription]
}

resource "null_resource" "os_remove_node_sensor" {
  count = var.sensor_type == "FalconNodeSensor" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconnodesensor -A --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.os_operator_subscription]
}

resource "null_resource" "os_remove_admission_controller" {
  count = var.falcon_admission ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconadmissions falcon-admission"
    when    = destroy
  }
  depends_on = [kubectl_manifest.os_operator_subscription]
}
