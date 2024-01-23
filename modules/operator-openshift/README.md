<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon Sensor Operator

## Introduction

Falcon Node Sensor and Falcon Container Sensor are CrowdStrike products that provide runtime protection to the nodes and pods.

If you choose to install Falcon Node Sensor the operator will manage Kubernetes DaemonSet for you to deploy the Node Sensor onto each node of your kubernetes cluster. Alternatively, if you choose to install Falcon Container Sensor the operator will set-up deployment hook on your cluster so every new deployment will get Falcon Container inserted in each pod.

Detailed documentation for [FalconNodeSensor](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/node) and [FalconContainer](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/container) can be found in the [falcon-operator](https://github.com/CrowdStrike/falcon-operator) repository.

## Pre-requisites

You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

| Scope Name                  | Permission |
|-----------------------------|------------|
| Falcon Images Download      | **Read**   |
| Sensor Download             | **Read**   |

Credentials (`client_id` and `client_secret`) from this step will be used in deployment.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.2.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.14.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| <a name="input_operator_version"></a> [operator\_version](#input\_operator\_version) | Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo. | `string` | `"v0.9.1"` | no |
| <a name="input_sensor_type"></a> [sensor\_type](#input\_sensor\_type) | Falcon sensor type: FalconNodeSensor or FalconContainer. | `string` | `"FalconNodeSensor"` | no || <a name="falcon_admission"></a> [falcon_admission](#input\falcon_admission) | Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster. | `bool` | 'true' | no |
| <a name="input_node_sensor_mode"></a> [node\_sensor\_mode](#input\_node\_sensor\_mode) | Falcon Node Sensor mode: 'kernel' or 'bpf'. | `string` | `"bpf"` | no |
## Outputs

No outputs.

## Usage

```hcl
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
```
<!-- END_TF_DOCS -->
