<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon

This repository contains modules that can be used to automate the deployment of the CrowdStrike Falcon Sensor, Falcon Admission Controller (KAC) and the Kubernetes Protection Agent (KPA) on a Kubernetes cluster.

Learn more about each module:

| Module                                                           | Description               |
| ---------------------------------------------------------------- | ------------------------- |
| [operator](./modules/operator/README.md)                         | Manages Falcon Sensor and KAC deployments |
| [operator-openshift](./modules/operator-openshift/README.md)               | Manages Falcon Sensor and KAC deployments on OpenShift |
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
| client_id | Falcon API Client Id | `string` | n/a | yes |
| client_secret | Falcon API Client Secret | `string` | n/a | yes |
| cloud | Falcon Cloud Region to use. | `string` | n/a | yes |
| cid | Customer ID (CID) of the Falcon platform. | `string` | n/a | If falcon_kpa = true or ecr = true |
| cluster_name | Your Cluster Name | `string` | n/a | If falcon_kpa = true |
| docker_api_token | Falcon Docker API Token | `string` | n/a | If falcon_kpa = true |
| ecr | Whether to mirror Falcon Sensor Images to ECR.  This allows Falcon Operator source Node Sensor image from ECR (if sensor_type = FalconNodeSensor) and automatically mirror Falcon Admission Controller (if falcon_admission = true) and FalconContainer Sensor (if sensor_type = FalconContainer) to AWS ECR | `bool` | `false` | no |
| ecr_node_sensor_uri | ECR URI of the Falcon Node Sensor Image.  For more information on how to push the Falcon Sensor images to ECR see [falcon-container-sensor-pull](https://github.com/CrowdStrike/falcon-scripts/tree/main/bash/containers/falcon-container-sensor-pull). | `string` | n/a | If sensor_type = FalconNodeSensor AND ecr = true |
| environment | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| operator_version | Falcon Operator version to deploy. Can be a branch, tag, or commit hash of the falcon-operator repo. | `string` | `"v0.9.1"` | no |
| sensor_type | Falcon sensor type: FalconNodeSensor or FalconContainer. Requires `platform = kubernetes` | `string` | `"FalconNodeSensor"` | no |
| node_sensor_mode | Falcon Node Sensor mode: 'kernel' or 'bpf'. | `string` | `"bpf"` | no |
| falcon_kpa | Whether to deploy the Falcon Kubernetes Protection Agent to the cluster. | `bool` | `true` | no |
| falcon_admission | Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster. | `bool` | `true` | no |
| platform | Whether to deploy on kubernetes or OpenShift. | `string` | `"kubernetes"` | no |
| node_sensor_manifest_path | Deploy node sensor from custom manifest file. For more info on how avaliable options see [Falcon Node Sensor](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/node/README.md) | `string` | n/a | no |
| container_sensor_manifest_path | Deploy container sensor from custom manifest file. For more info on how avaliable options see [Falcon Container Sensor](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/container/README.md) | `string` | n/a | no |
| admission_controller_manifest_path | Deploy admission controller from custom manifest file. For more info on how avaliable options see [Falcon Admission Controller](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/admission/README.md) | `string` | n/a | no |


## Usage
### The following example demonstrates the following:
- retrieve CrowdStrike API credentials from Secrets manager.
- deploy Falcon Node Sensor
- deploy Falcon Admission Controller
- deploy Falcon Kubernetes Protection Agent
- Mirror Images to ECR
- Retrieve Falcon Node Sensor from ECR

```hcl
provider "aws" {
  region = us-east-1
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id     = data.aws_secretsmanager_secret.falcon_secrets.id
  version_stage = var.aws_secret_version_stage
}

locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
}

module "crowdstrike_falcon" {
  source = "CrowdStrike/falcon/kubectl"
  version = "0.5.0"

  cid                 = local.secrets["cid"]
  client_id           = local.secrets["client_id"]
  client_secret       = local.secrets["client_secret"]
  cloud               = local.secrets["cs_cloud"]
  docker_api_token    = local.secrets["docker_api_token"]
  cluster_name        = "my-cluster"
  platform            = "kubernetes"
  sensor_type         = "FalconNodeSensor"
  falcon_admission    = true
  falcon_kpa          = true
  ecr                 = true
  ecr_node_sensor_uri = "123456789123.dkr.ecr.us-east-1.amazonaws.com/crowdstrike/falcon-sensor:7.11.0-16407-1.falcon-linux.x86_64.Release.US-1"
}
```

### The following example demonstrates the following:
- retrieve CrowdStrike API credentials from Secrets manager.
- deploy Falcon Container Sensor from custom manifest file
- deploy Falcon Admission Controller from custom manifest file

```hcl
provider "aws" {
  region = us-east-1
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id     = data.aws_secretsmanager_secret.falcon_secrets.id
  version_stage = var.aws_secret_version_stage
}

locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
}

module "crowdstrike_falcon" {
  source = "CrowdStrike/falcon/kubectl"
  version = "0.5.0"

  cid                                = local.secrets["cid"]
  client_id                          = local.secrets["client_id"]
  client_secret                      = local.secrets["client_secret"]
  cloud                              = local.secrets["cs_cloud"]
  platform                           = "kubernetes"
  sensor_type                        = "FalconContainer"
  falcon_admission                   = true
  falcon_kpa                         = false
  container_sensor_manifest_path     = "/path/to/file.yaml"
  admission_controller_manifest_path = "/path/to/file.yaml"
}
```
<!-- END_TF_DOCS -->
