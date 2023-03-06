# Getting Started

GreenOps can be installed fully on-prem, or via a dedicated SaaS. This installation setup describes how to install GreenOps on-prem. For a dedicated SaaS walkthrough, please reach out [here]().

## Pre-setup
Create the namespaces you will need to set up GreenOps.

```
kubectl create ns greenops
kubectl create ns gitcred
kubectl create ns argo
kubectl create ns argocd
```

Set up the license and Docker credentials so that GreenOps images can be downloaded and used.

```
kubectl create secret generic greenops-license --from-literal=license=<LICENSE> -n greenops
```

```
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=<USERNAME> --docker-password=<PASSWORD> --docker-email=<EMAIL> -n greenops
```

## Install the GreenOps control plane
Fetch the GreenOps Helm chart repository...

```
helm repo add greenops https://greenopsinc.github.io/charts
helm repo update greenops
```

and install the control plane. GreenOps requires some kind of URL (Ingress, LoadBalancer, or NodePort if the entire installation is in one cluster). Enter the defined GreenOps address into the `<GREENOPS_URL>` section of the install command.

```
helm install greenops ./greenops-1.0.1-rc.tgz --set 'common.server.greenopsUrl=<GREENOPS_URL>'
```

The chart also automatically sets up a Redis instance as a part of the deployment. A different Redis instance can also be linked by setting the address and password (optional) in the [values.yaml file](https://github.com/GreenOpsInc/get-started/blob/main/greenops/values.yaml#L3).

The GreenOps URL can also be set in the `values.yaml` file if desired.

```
$ kubectl get pods -n greenops

NAME                                         READY   STATUS    RESTARTS      AGE
greenops-commanddelegator-6c77c4b578-v28jt   1/1     Running   0             11m
greenops-controller-744b5f6fdf-7j4vx         1/1     Running   0             11m
greenops-reposerver-6d7c657758-6f9q8         1/1     Running   0             11m
greenops-server-77fbb69c7c-8vnhx             1/1     Running   0             11m
redisserver-5698db48bb-4k7sz                 1/1     Running   0             11m
```

You should see something that looks like this after a successful install.

### Exposing GreenOps
Here is an [example ingress configuration](https://raw.githubusercontent.com/GreenOpsInc/get-started/main/greenops-ingress.yaml) if you would like to expose the GreenOps control plane. The control plane can also be port-forwarded for simple testing purposes.

## Accessing the control plane
Once the GreenOps control plane is up and running, let's access it to setup a cluster.

![Screenshot](https://greenops.io/go-docs/img/login-page.png)

SSO can be enabled through the Helm chart linked above, but for now let's use the admin login for access. The username is `admin`, and the password is:

```
kubectl -n greenops get secret greenops-base-auth-token -o jsonpath="{.data.data}" | base64 -d; echo
```

After logging in, you should be able to see this page:

![Screenshot](https://greenops.io/go-docs/img/blank-org-page.png)

## Registering a cluster

###Setting up Argo Workflows
To register a cluster, first we have to set up Argo Workflows. A quickstart is provided [here](https://github.com/GreenOpsInc/get-started/tree/main/argo-workflows). Before deploying, update the empty spaces in the manifest for the `FRAME_ANCESTOR` in the [environment variables section](https://github.com/GreenOpsInc/get-started/blob/main/argo-workflows/quick-start-postgres.yaml#L1708) and `--access-control-allow-origin` in the [arguments section](https://github.com/GreenOpsInc/get-started/blob/main/argo-workflows/quick-start-postgres.yaml#L1702). Both of the values should be the GreenOps URL.

The manifest can be installed as a file:

```
kubectl apply -f argo-workflows/quick-start-postgres.yaml -n argo
```

Or via copy/paste:

```
kubectl apply -n argo -f - <<EOF
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: clusterworkflowtemplates.argoproj.io
spec:
  group: argoproj.io
...
...
EOF
```

An accessible URL should also be set up for Argo Workflows. This can be via Ingress, LoadBalancer, or NodePort if the entire installation is in one cluster.

*Soon Argo Workflows can be managed by GreenOps, and can be installed automatically after registering a cluster.*

### Setting up a GreenOps agent
After setting up Argo Workflows, let's navigate to the GreenOps cluster page:

![Screenshot](https://greenops.io/go-docs/img/blank-cluster-page.png)

Press the `+` button and enter the name of the cluster. A token will be generated that looks like this:

![Screenshot](https://greenops.io/go-docs/img/generated-token.png)

Create a secret for the generated token:

```
kubectl create secret generic greenops-apikey-secret --from-literal=apikey=<TOKEN> -n greenops
```

Using the Helm chart, install the `greenops-daemon` package. Use the cluster name entered earlier and the Argo Workflows URL generated earlier for `<CLUSTER_NAME>` and `<ARGO_WORKFLOWS_URL>`.

**Note**: Do not add `https://` in front of any URLs. An example of `<ARGOCD_URL>` would be `argocd-server.argocd.svc.cluster.local`.

```
helm install greenops-daemon ./greenops-daemon-1.0.1-rc.tgz --set 'common.clusterName=<CLUSTER_NAME>' --set 'common.argo.workflows.url=<ARGO_WORKFLOWS_URL>' --set 'common.greenopsServer.url=<GREENOPS_URL>' --set 'common.commandDelegator.url=<GREENOPS_URL>' --set 'common.argo.cd.internalUrl=<ARGOCD_URL>'
```

You should now be able to see a green check mark next to the cluster on the GreenOps UI. It may take up to 30 seconds to register.

![Screenshot](https://greenops.io/go-docs/img/registered-cluster.png)

### Enabling private instances

To do this, a TCP port has to be added to the ingress controller for connectivity. The [ingress section](ingress/) has a guide for setting this up.

## What's next?

Now that GreenOps is set up, you can now build all the CI/CD pipelines you want, lightning fast. So what's next?

* [Setting up Argo CD instances across clusters](buildbook/cluster-argo-configuration.md)
* [Building your first pipeline with GreenOps](buildbook/walkthroughs/walkthroughs.md)
* [Configuring SSO](management/auth.md)
