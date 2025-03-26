<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon Sensor Operator

## Introduction

Falcon Node Sensor and Falcon Container Sensor are CrowdStrike products that provide runtime protection to the nodes and pods.

If you choose to install Falcon Node Sensor the operator will manage Kubernetes DaemonSet for you to deploy the Node Sensor onto each node of your kubernetes cluster. Alternatively, if you choose to install Falcon Container Sensor the operator will set-up deployment hook on your cluster so every new deployment will get Falcon Container inserted in each pod.

Falcon Admission Controller is a CrowdStrike product that monitors and reviews Kubernetes objects when they are created or updated.

Falcon Image Analyzer is a CrowdSrike product that enabled Image Assessment at Runtime (IAR) to support container image assessment as soon as containers are launched on the host node in a Kubernetes or cloud environment.

Detailed documentation for [FalconNodeSensor](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/node), [FalconContainer](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/resources/container), [FalconAdmission](https://github.com/CrowdStrike/falcon-operator/blob/main/docs/resources/admission/README.md) and [FalconImageAnalyzer](https://github.com/CrowdStrike/falcon-operator/blob/main/docs/resources/imageanalyzer/README.md) can be found in the [falcon-operator](https://github.com/CrowdStrike/falcon-operator) repository.

## Pre-requisites

You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

| Scope Name                  | Permission             |
|-----------------------------|------------------------|
| Falcon Images Download      | **Read**               |
| Sensor Download             | **Read**               |
| Falcon Container CLI        | **Write**              |
| Falcon Container Image      | **Read** and **Write** |

Credentials (`client_id` and `client_secret`) from this step will be used in deployment.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.14.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.os_falcon_admission_controller](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.os_falcon_node_sensor](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.os_iar](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.os_operator_group](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.os_operator_project](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.os_operator_subscription](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [null_resource.os_remove_admission_controller](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.os_remove_iar](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.os_remove_node_sensor](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.admission_controller_manifest](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.iar_manifest](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.node_sensor_manifest](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admission_controller_manifest_path"></a> [admission\_controller\_manifest\_path](#input\_admission\_controller\_manifest\_path) | n/a | `string` | `"default"` | no |
| <a name="input_cleanup"></a> [cleanup](#input\_cleanup) | Whether to cleanup resources on destroy. | `bool` | `true` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_container_sensor_manifest_path"></a> [container\_sensor\_manifest\_path](#input\_container\_sensor\_manifest\_path) | n/a | `string` | `"default"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| <a name="input_falcon_admission"></a> [falcon\_admission](#input\_falcon\_admission) | Whether to deploy the FalconAdmission Custom Resource (CR) to the cluster. | `bool` | `true` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Falcon Cloud Region to use. | `string` | n/a | no |
| <a name="input_iar"></a> [iar](#input\_iar) | Whether to deploy the Falcon Image Analyzer Custom Resource (CR) to the cluster. | `bool` | `false` | no |
| <a name="input_iar_manifest_path"></a> [iar\_manifest\_path](#input\_iar\_manifest\_path) | n/a | `string` | `"default"` | no |
| <a name="input_node_sensor_manifest_path"></a> [node\_sensor\_manifest\_path](#input\_node\_sensor\_manifest\_path) | n/a | `string` | `"default"` | no |
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
