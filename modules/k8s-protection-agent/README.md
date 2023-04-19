<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Kubernetes Protection Agent

## Introduction

The Kubernetes Protection Agent provides visibility into the cluster by collecting event information from the Kubernetes layer. These events are correlated to sensor events and cloud events to provide complete cluster visibility.

## Prerequisites

1. You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

    | Scope Name                  | Permission             |
    | --------------------------- | ---------------------- |
    | Kubernetes Protection Agent | **Write**              |
    | Kubernetes Protection       | **Read** and **Write** |

2. You need a CrowdStrike Docker API Token and CID. See [How to retrieve your Falcon Docker API Token and CID](#how-to-retrieve-your-falcon-docker-api-token-and-cid) for instructions on how to retrieve your Docker API Token and CID.

## How to retrieve your Falcon Docker API Token and CID

<details>
<summary>Using the console</summary>

1. Log in to Falcon Console
2. Navigate to https://falcon.crowdstrike.com/cloud-security/registration?return_to=eks
3. Click Register New Kubernetes Cluster
4. Click Self-Managed Kubernetes Service
5. Type any value for Cluster Name and click Generate
6. The generated config will contain both your Docker API Token and CID

</details>

<details>
<summary>Using the helper script</summary>

1. Add the following environment variables with your values.
    ```shell
    export FALCON_CLOUD=api.us-2.crowdstrike.com
    export FALCON_CLIENT_ID=123123123
    export FALCON_CLIENT_SECRET=12312313
    ```
    > Note: The scopes mentioned [above](#prerequisites) are required for this script to work.

2. Run the script.
    ```shell
    curl -L https://raw.githubusercontent.com/crowdStrike/terraform-kubectl-falcon/main/modules/k8s-protection-agent/examples/generate_prerequisites.sh | bash
    ```
    # Example output
    ```shell
    Docker Access Token: AKSADKLDK
    Falcon CCID: AKFJKLAJFLK-0F
    ```
</details>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.8.0 |
## Resources

| Name | Type |
|------|------|
| [helm_release.kpagent](https://registry.terraform.io/providers/hashicorp/helm/2.8.0/docs/resources/release) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cid"></a> [cid](#input\_cid) | Customer ID (CID) of the Falcon platform. | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client Id | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Falcon Cloud Region to use. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Your Cluster Name | `string` | n/a | yes |
| <a name="input_docker_api_token"></a> [docker\_api\_token](#input\_docker\_api\_token) | Falcon Docker API Token | `string` | n/a | yes |
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

module "crowdstrike_kpa" {
  source = "github.com/CrowdStrike/terraform-kubectl-falcon//modules/k8s-protection-agent?ref=v0.1.0"

  cid              = local.secrets["cid"]
  client_id        = local.secrets["client_id"]
  client_secret    = local.secrets["client_secret"]
  cloud            = var.cloud
  cluster_name     = local.cluster_name
  docker_api_token = local.secrets["docker_api_token"]
}
```
<!-- END_TF_DOCS -->
