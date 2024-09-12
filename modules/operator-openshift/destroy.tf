resource "null_resource" "os_remove_node_sensor" {
  count = var.cleanup ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconnodesensor -A --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.os_operator_subscription]
}

resource "null_resource" "os_remove_admission_controller" {
  count = var.cleanup && var.falcon_admission ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete falconadmissions falcon-admission"
    when    = destroy
  }
  depends_on = [kubectl_manifest.os_operator_subscription]
}
