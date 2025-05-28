locals {
  region       = var.region
  cloud        = var.cloud
  cluster_name = var.cluster_name
  secrets      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
}

provider "aws" {
  region = local.region
}

# Example of using secrets stored in AWS Secrets Manager
data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id     = data.aws_secretsmanager_secret.falcon_secrets.id
  version_stage = var.aws_secret_version_stage
}

module "crowdstrike_operator" {
  source  = "CrowdStrike/falcon/kubectl//modules/operator-openshift"
  version = "0.7.1"

  client_id     = local.secrets["client_id"]
  client_secret = local.secrets["client_secret"]
  cloud         = local.cloud
}
