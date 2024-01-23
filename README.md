<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon

This repository contains modules that can be used to automate the deployment of the CrowdStrike Falcon Sensor and the Kubernetes Protection Agent on a Kubernetes cluster.

Learn more about each module:

| Module                                                           | Description               |
| ---------------------------------------------------------------- | ------------------------- |
| [operator](./modules/operator/README.md)                         | Manages sensor deployment |
| [operator-openshift](./modules/operator/README.md)               | Manages sensor deployment on OpenShift |
| [k8s-protection-agent](./modules/k8s-protection-agent/README.md) | Manage KPA deployment     |

## Pre-requisites

1. You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

    | Scope Name                  | Permission             |
    | --------------------------- | ---------------------- |
    | Falcon Images Download      | **Read**               |
    | Sensor Download             | **Read**               |
    | Kubernetes Protection Agent | **Write**              |
    | Kubernetes Protection       | **Read** and **Write** |

2. You need a CrowdStrike Docker API Token and CID. See [How to retrieve your Falcon Docker API Token and CID](./modules//k8s-protection-agent/README.md#how-to-retrieve-your-falcon-docker-api-token-and-cid) for instructions on how to retrieve your Docker API Token and CID.

## Providers

No providers.
## Resources

No resources.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cid"></a> [cid](#input\_cid) | Customer ID (CID) of the Falcon platform. | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client Id | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Falcon Cloud Region to use. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Your Cluster Name | `string` | n/a | yes |
| <a name="input_docker_api_token"></a> [docker\_api\_token](#input\_docker\_api\_token) | Falcon Docker API Token | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| <a name="input_operator_version"></a> [operator\_version](#input\_operator\_version) | Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo. | `string` | `"v0.7.2"` | no |
| <a name="input_sensor_type"></a> [sensor\_type](#input\_sensor\_type) | Falcon sensor type: FalconNodeSensor or FalconContainer. | `string` | `"FalconNodeSensor"` | no |
| <a name="input_node_sensor_mode"></a> [node\_sensor\mode](#input\_node\_sensor\_mode) | Falcon Node Sensor mode: 'kernel' or 'bpf'. | `string` | `"bpf"` | no |
| <a name="falcon_admission"></a> [falcon\_admission](#input\falcon_admission) | Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster. | `bool` | 'true' | no |
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

module "crowdstrike_falcon" {
  source = "CrowdStrike/falcon/kubectl"
  version = "0.4.0"

  cid              = local.secrets["cid"]
  client_id        = local.secrets["client_id"]
  client_secret    = local.secrets["client_secret"]
  cloud            = var.cloud
  cluster_name     = local.cluster_name
  docker_api_token = local.secrets["docker_api_token"]
  platform         = "kubernetes"
}
```
<!-- END_TF_DOCS -->
