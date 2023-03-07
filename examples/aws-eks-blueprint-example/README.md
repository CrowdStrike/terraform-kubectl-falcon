# EKS Cluster w/ CrowdStrike Falcon

This example shows how to provision an EKS cluster with CrowdStrike Falcon enabled.

## Prerequisites:

Ensure that you have the following tools installed locally:

1. [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [kubectl](https://Kubernetes.io/docs/tasks/tools/)
3. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

Ensure AWS Secrets Manager secret named `crowdstrike_falcon_addon/secrets` exists with the following

- `client_id`
- `client_secret`
- `docker_api_token`
- `cid`


Api keys can be created at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

For Falcon Operator:
 - Falcon Images Download: **Read**
 - Sensor Download: **Read**

For Falcon KPA:
  - Kubernetes Protection Agent: **Write**

You can get both your cid and docker_api_token by:

1. Log in to Falcon Console
2. Navigate to https://falcon.crowdstrike.com/cloud-security/registration?return_to=eks
3. Click Register New Kubernetes Cluster
4. Click Self-Managed Kubernetes Service
5. Type any value for Cluster Name and click Generate
6. The generated config will contain both your Docker API Token and CID


## Deploy

To provision this example:

```sh
terraform init
terraform apply
```

Enter `yes` at command prompt to apply


## Validate

The following command will update the `kubeconfig` on your local machine and allow you to interact with your EKS Cluster using `kubectl` to validate the deployment.

1. Run `update-kubeconfig` command:

```sh
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME>
```

2. List the nodes running currently

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
