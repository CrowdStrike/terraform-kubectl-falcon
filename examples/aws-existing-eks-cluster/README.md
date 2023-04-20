# EKS Cluster w/ CrowdStrike Falcon

This example deploys CrowdStrike Falcon to an existing EKS cluster.

## Pre-requisites:

Ensure that you have the following tools installed locally:

1. [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [kubectl](https://Kubernetes.io/docs/tasks/tools/)
3. [helm](https://helm.sh/docs/intro/install/)
4. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Deploy

To provision this example:

Set the following environment variables:

```sh
export TF_VAR_client_id=<your_client_id>
export TF_VAR_client_secret=<your_client_secret>
export TF_VAR_docker_api_token=<your_docker_api_token>
export TF_VAR_cid=<your_cid>
```

See [Pre-requisites](../../README.md#pre-requisites) for instructions on how to generate your client_id, client_secret, docker_api_token, and cid.

Run the following commands:

```sh
terraform init
terraform apply
```

Provide the required inputs when prompted.

## Validate

The following command will update the `kubeconfig` on your local machine and allow you to interact with your EKS Cluster using `kubectl` to validate the deployment.

1. Run `update-kubeconfig` command:

After the terraform apply is complete, you will see output that similar to the below:

```sh
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-2 update-kubeconfig --name aws-eks-blueprint-example"
```

Copy the value of `configure_kubectl` and run it in your terminal to update your kubeconfig. Now you can run `kubectl` commands against your cluster.


1. List the nodes running currently

```sh
kubectl get nodes

# Output should look like below
NAME                                        STATUS                        ROLES    AGE     VERSION
ip-10-0-30-125.us-west-2.compute.internal   Ready                         <none>   2m19s   v1.22.9-eks-810597c
```

3. List out the pods running currently:

```sh
kubectl get pods -A

# Output should contain both falcon-operator and falcon-kpa pods
NAMESPACE                      NAME                                                  READY   STATUS    RESTARTS   AGE
falcon-kubernetes-protection   kpagent-cs-k8s-protection-agent-77c6bcdcdf-bg2cj      1/1     Running   0          12s
falcon-operator                falcon-operator-controller-manager-76f688b855-p66lx   1/1     Running   0          9m52s
kube-system                    aws-node-tvgfr                                        1/1     Running   0          8m26s
kube-system                    coredns-5c5677bc78-6mnzf                              1/1     Running   0          13m
kube-system                    coredns-5c5677bc78-n2wcr                              1/1     Running   0          13m
kube-system                    kube-proxy-fccbs                                      1/1     Running   0          8m26s
```

## Destroy

To teardown and remove the resources created in this example:

```sh
terraform destroy -auto-approve
```
