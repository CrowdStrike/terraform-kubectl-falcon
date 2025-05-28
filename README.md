<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon

This repository contains modules that can be used to automate the deployment of the CrowdStrike Falcon Sensor, Falcon Admission Controller (KAC) and Falcon Image Analyzer (IAR) on a Kubernetes cluster.

Learn more about each module:

| Module                                                           | Description               |
| ---------------------------------------------------------------- | ------------------------- |
| [operator](./modules/operator/README.md)                         | Manages Falcon Sensor, KAC and IAR deployments |
| [operator-openshift](./modules/operator-openshift/README.md)     | Manages Falcon Sensor, KAC and IAR deployments on OpenShift |

## Pre-requisites

1. You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

    | Scope Name                  | Permission             |
    | --------------------------- | ---------------------- |
    | Falcon Images Download      | **Read**               |
    | Sensor Download             | **Read**               |
    | Falcon Container CLI        | **Write**              |
    | Falcon Container Image      | **Read** and **Write** |

## Providers

No providers.
## Resources

No resources.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admission_controller_manifest_path"></a> [admission\_controller\_manifest\_path](#input\_admission\_controller\_manifest\_path) | Path to kubernetes file for the Admission Controller | `string` | `"default"` | no |
| <a name="input_cleanup"></a> [cleanup](#input\_cleanup) | Whether to cleanup resources on destroy. | `bool` | `true` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client Id | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Falcon Cloud Region | `string` | `"us-1"` | no |
| <a name="input_container_sensor_manifest_path"></a> [container\_sensor\_manifest\_path](#input\_container\_sensor\_manifest\_path) | Path to kubernetes file for the Container Sensor | `string` | `"default"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| <a name="input_falcon_admission"></a> [falcon\_admission](#input\_falcon\_admission) | Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster. | `bool` | `true` | no |
| <a name="input_iar"></a> [iar](#input\_iar) | Whether to deploy the Falcon Image Analyzer Custom Resource (CR) to the cluster. | `bool` | `true` | no |
| <a name="input_iar_manifest_path"></a> [iar\_manifest\_path](#input\_iar\_manifest\_path) | Path to kubernetes file for IAR | `string` | `"default"` | no |
| <a name="input_node_manifest_path"></a> [node\_manifest\_path](#input\_node\_manifest\_path) | Path to kubernetes file for the Node Sensor | `string` | `"default"` | no |
| <a name="input_node_sensor_mode"></a> [node\_sensor\_mode](#input\_node\_sensor\_mode) | Falcon Node Sensor mode: 'kernel' or 'bpf'. | `string` | `"bpf"` | no |
| <a name="input_operator_version"></a> [operator\_version](#input\_operator\_version) | Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo. | `string` | `"v1.4.0"` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | Specify whether your cluster is managed by kubernetes or openshift. | `string` | `"kubernetes"` | no |
| <a name="input_sensor_type"></a> [sensor\_type](#input\_sensor\_type) | Falcon sensor type: FalconNodeSensor or FalconContainer. | `string` | `"FalconNodeSensor"` | no |
## Outputs

No outputs.

## Usage

```hcl
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

module "crowdstrike_falcon" {
  source  = "CrowdStrike/falcon/kubectl"
  version = "0.7.1"

  client_id     = local.secrets["client_id"]
  client_secret = local.secrets["client_secret"]
  cloud         = local.cloud
}
```
<!-- END_TF_DOCS -->
