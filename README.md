<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon

This repository contains modules that can be used to automate the deployment of the CrowdStrike Falcon Sensor and the Kubernetes Protection Agent on a Kubernetes cluster.

Learn more about each module:

| Module                                                            | Description               |
|-------------------------------------------------------------------|---------------------------|
| [operator](./modules/operator/README.md)                         | Manages sensor deployment |
| [k8s-protection-agent](./modules/k8s-protection-agent/README.md) | Manage KPA deployment     |

## Pre-requisites

1. You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

    | Scope Name                  | Permission |
    |-----------------------------|------------|
    | Falcon Images Download      | **Read**   |
    | Sensor Download             | **Read**   |
    | Kubernetes Protection Agent | **Write**  |

2. You need a CrowdStrike Docker API Toke and CID. See [How to retrieve your Falcon Docker API Token and CID](./modules//k8s-protection-agent/README.md#how-to-retrieve-your-falcon-docker-api-token-and-cid) for instructions on how to retrieve your Docker API Token and CID.
## Providers

No providers.
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_falcon_kpa"></a> [falcon\_kpa](#module\_falcon\_kpa) | ./modules/k8s-protection-agent | n/a |
| <a name="module_falcon_operator"></a> [falcon\_operator](#module\_falcon\_operator) | ./modules/operator | n/a |
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
| <a name="input_sensor_type"></a> [sensor\_type](#input\_sensor\_type) | Falcon sensor type: FalconNodeSensor or FalconContainer. | `string` | `"FalconNodeSensor"` | no |
## Outputs

No outputs.
<!-- END_TF_DOCS -->
