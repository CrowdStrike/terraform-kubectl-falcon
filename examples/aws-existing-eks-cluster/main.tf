provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

module "crowdstrike_falcon" {
  source  = "CrowdStrike/falcon/kubectl"
  version = "0.3.0"

  cid              = var.cid
  client_id        = var.client_id
  client_secret    = var.client_secret
  cloud            = var.cloud
  cluster_name     = data.aws_eks_cluster.this.arn
  docker_api_token = var.docker_api_token
}
