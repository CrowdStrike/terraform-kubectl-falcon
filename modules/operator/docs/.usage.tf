provider "aws" {
  region = local.region
}

# Example of using secrets stored in AWS Secrets Manager
data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id     = data.aws_secretsmanager_secret.falcon_secrets.id
  version_stage = var.aws_secret_version_stage
}

locals {
  cluster_name = "cluster-name"
  region       = var.region

  secrets = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
}

module "crowdstrike_operator" {
  source = "github.com/CrowdStrike/terraform-kubectl-falcon//modules/operator?ref=v0.1.0"

  client_id        = local.secrets["client_id"]
  client_secret    = local.secrets["client_secret"]
}
