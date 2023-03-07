<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# CrowdStrike Falcon Sensor Operator

## Introduction

Falcon Node Sensor and Falcon Container Sensor are CrowdStrike products that provide runtime protection to the nodes and pods.

If you choose to install Falcon Node Sensor the operator will manage Kubernetes DaemonSet for you to deploy the Node Sensor onto each node of your kubernetes cluster. Alternatively, if you choose to install Falcon Container Sensor the operator will set-up deployment hook on your cluster so every new deployment will get Falcon Container inserted in each pod.

Detailed documentation for [FalconNodeSensor](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/node) and [FalconContainer](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/container) can be found in the [falcon-operator](https://github.com/CrowdStrike/falcon-operator) repository.

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
## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.falcon_container_sensor](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.falcon_node_sensor](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.falcon_operator](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [http_http.falcon_operator](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [kubectl_file_documents.docs](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/file_documents) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment or 'Alias' tag | `string` | `"tf_module"` | no |
| <a name="input_sensor_type"></a> [sensor\_type](#input\_sensor\_type) | Falcon sensor type: FalconNodeSensor or FalconContainer. | `string` | `"FalconNodeSensor"` | no |
## Outputs

No outputs.
<!-- END_TF_DOCS -->
