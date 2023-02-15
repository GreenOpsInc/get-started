Installation Notes:

- **Provider Configuration:** Providers are not configured. The starter Terraform markup for the GreenOps control plane and GreenOps agent use the Helm provider and the Kubernetes provider. The configuration has been left blank for users to fill in.

The areas to fill in this configuration can be found in `greenops-control-plane/greenops-control-plane.tf` and `greenops-agent/greenops-agent.tf`

- **Modules and Multi-Cluster:** There will only be one GreenOps control plane, so everything is largely set up in one file. The GreenOps agent, however, can be set up across multiple environments/clusters. The agent installation can be done via module, where the desired destination environments can be configured and then passed down. This makes agent management extremely simple. An example for this module usage can be found in `greenops-agent/greenops-agent.tf`. The module definition can be found in `greenops-agent/greenops-agent-reusable-module`.

- **HTTP Requests:** The agent Terraform configuration makes a POST request to the GreenOps API. Because HTTPS requests go through the data sources flow, the request will be executed during the `plan` stage. Remember to use the `-out` flag when running `terraform plan`, and to use the staged file for `terraform apply`.

- **Separate Configs for Control Plane & Agent:** The agent configuration requires a developer access token to be able to make a secure remote request to GreenOps. This token has to be fetched from the UI (allowing a token to be fetched remotely would introduce a security risk). Terraform will prompt for the token when installing an agent.

Putting It All Together:

**Providers**: *This flow expects that Helm and Kubernetes providers have already been configured. See the first installation note for more info.*

**Ingress**: *This flow expects that ingress is already configured, or configured separately.*

**Namespaces**: *This flow expects that the `greenops`, `gitcred`, `argo`, and `argocd` namespaces already exist. If they don't, run this:*
```
kubectl create ns greenops
kubectl create ns gitcred
kubectl create ns argo
kubectl create ns argocd
```

1. Using the `terraform-setup` as the root, navigate to the `greenops-control-plane` folder and run:
```
cd greenops-control-plane
terraform init
terraform plan -out tf-control-plane-plan
terraform apply "tf-control-plane-plan"
```
*Do not add `https://` when prompted for a URL.*

2. Login as the admin user, and navigate to the GreenOps settings tab. Create a developer token and save it somewhere private, you will use it for the next step.

3. Navigate to the `greenops-agent` folder and run:
```
cd greenops-agent
terraform init
terraform plan -out tf-agent-plan
terraform apply "tf-agent-plan"
```
*Do not add `https://` when prompted for a URL.*

After this, both the control plane and agent should be set up!
