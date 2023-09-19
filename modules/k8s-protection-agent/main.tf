resource "null_resource" "lower_cid" {
  provisioner "local-exec" {
    command = <<-EOF
      cid=${var.cid}
      trim_cid=$(echo $cid | rev | cut -c 4- | rev)
      my_cid=$(echo $trim_cid | tr '[:upper:]' '[:lower:]')
      printf $my_cid > cid.txt
    EOF
  }
}

data "local_file" "lower_cid" {
    filename = "cid.txt"
  depends_on = [null_resource.lower_cid]
}

resource "helm_release" "kpagent" {
  name             = "kpagent"
  chart            = "cs-k8s-protection-agent"
  repository       = "https://registry.crowdstrike.com/kpagent-helm"
  namespace        = "falcon-kubernetes-protection"
  create_namespace = true
  reset_values     = true

  set {
    name  = "crowdstrikeConfig.clientID"
    value = var.client_id
  }

  set {
    name  = "crowdstrikeConfig.clientSecret"
    value = var.client_secret
  }

  set {
    name  = "crowdstrikeConfig.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "crowdstrikeConfig.env"
    value = var.cloud
  }

  set {
    name  = "crowdstrikeConfig.cid"
    value = data.local_file.lower_cid.content
  }

  set {
    name  = "crowdstrikeConfig.dockerAPIToken"
    value = var.docker_api_token
  }
}
