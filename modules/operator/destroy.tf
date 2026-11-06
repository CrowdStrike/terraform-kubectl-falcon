
resource "null_resource" "remove_container_sensor" {
  count = var.cleanup && var.sensor_type == "FalconContainer" ? 1 : 0

  # Store context flag in triggers so destroy provisioners can reference it via self (SOLAR-2685).
  # Destroy-time provisioners cannot reference locals or other resources directly.
  triggers = {
    context_flag = var.kubectl_context != "" ? "--context ${var.kubectl_context}" : ""
  }

  provisioner "local-exec" {
    command = "kubectl ${self.triggers.context_flag} delete falconcontainers.falcon.crowdstrike.com --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_node_sensor" {
  count = var.cleanup && var.sensor_type == "FalconNodeSensor" ? 1 : 0

  triggers = {
    context_flag = var.kubectl_context != "" ? "--context ${var.kubectl_context}" : ""
  }

  provisioner "local-exec" {
    command = "kubectl ${self.triggers.context_flag} delete falconnodesensors --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_admission_controller" {
  count = var.cleanup && var.falcon_admission ? 1 : 0

  triggers = {
    context_flag = var.kubectl_context != "" ? "--context ${var.kubectl_context}" : ""
  }

  provisioner "local-exec" {
    command = "kubectl ${self.triggers.context_flag} delete falconadmissions --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}

resource "null_resource" "remove_iar" {
  count = var.cleanup && var.iar ? 1 : 0

  triggers = {
    context_flag = var.kubectl_context != "" ? "--context ${var.kubectl_context}" : ""
  }

  provisioner "local-exec" {
    command = "kubectl ${self.triggers.context_flag} delete falconimageanalyzer --all"
    when    = destroy
  }
  depends_on = [kubectl_manifest.falcon_operator]
}
