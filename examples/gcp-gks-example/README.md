# GKE Cluster /w CrowdStrike Falcon

This example shows you how to provision a GKE cluster with CrowdStrike Falcon enabled.

## Prerequisites:

Ensure that you have the following tools installed locally:

1. [gcloud](https://cloud.google.com/sdk/docs/install)
2. [kubectl]](https://Kubernetes.io/docs/tasks/tools/)
3. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

Configure and authenticate gcloud:

```sh
gcloud init
gcloud auth application-default login
```

## Deploy

Update the `terraform.tfvars` file with with your desired values.

> Note: You can get project_id by running `gcloud config get-value project`

Set the following environment variables:

```sh
export TF_VAR_client_id=<your_client_id>
export TF_VAR_client_secret=<your_client_secret>
export TF_VAR_docker_api_token=<your_docker_api_token>
export TF_VAR_cid=<your_cid>
```

See [Pre-requisites](../../README.md#pre-requisites) for instructions on how to generate your client_id, client_secret, docker_api_token, and cid.


Run terraform:

```sh
terraform init
terraform apply --var-file=terraform.tfvars
```

## Validate

The following command will update the `kubeconfig` on your local machine and allow you to interact with your GKE Cluster using `kubectl` to validate the deployment.

1. Get the credentials for your GKE cluster:

After creation the following output will be displayed:

```sh
Outputs:

kubernetes_cluster_host = "1.111.11.11"
kubernetes_cluster_name = "project-id-falcon-example-gke"
kubernetes_get_credentials_command = "gcloud container clusters get-credentials project-id-falcon-example-gke --region us-east4 --project project-id"
project_id = "project-id"
region = "us-east4"
```

Copy the `kubernetes_get_credentials_command` and run it in your terminal to update your kubeconfig.

2. List the nodes running currently

```sh
kubectl get nodes

# Output should contain a list of nodes in the cluster
NAME                                                  STATUS   ROLES    AGE    VERSION
gke-project-id-falcon--default-pool-34449d35-1jfm     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-34449d35-9344     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-34449d35-ndmc     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-83000483-8r0d     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-83000483-fxv6     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-83000483-n754     Ready    <none>   116s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-fa3f1022-0660     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-fa3f1022-22qv     Ready    <none>   115s   v1.24.10-gke.2300
gke-project-id-falcon--default-pool-fa3f1022-s76j     Ready    <none>   113s   v1.24.10-gke.2300
```

1. List out the pods running currently:

```sh
kubectl get pods -A

# Output should contain both falcon-operator and falcon-kpa pods
NAMESPACE                      NAME                                                             READY   STATUS    RESTARTS   AGE
falcon-kubernetes-protection   kpagent-cs-k8s-protection-agent-7d8d84df45-2wfv4                 1/1     Running   0          10m
falcon-operator                falcon-operator-controller-manager-d944dc565-ldbgm               1/1     Running   0          10m
falcon-system                  falcon-node-sensor-b67nz                                         1/1     Running   0          6m8s
falcon-system                  falcon-node-sensor-thg8v                                         1/1     Running   0          13m
falcon-system                  falcon-node-sensor-zlkjp                                         1/1     Running   0          10m
...
```

## Destroy

To teardown and remove the resources created in this example:

```sh
terraform destroy -auto-approve
```
