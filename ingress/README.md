# Configuring ingress for GreenOps

See `greenops-ingress-nginx.yaml` for exposing GreenOps services. The example uses NGINX, but can be easily updated for other ingress types.

## Proxying Argo

GreenOps relies on some SSH protocols to provide a smooth, unified Argo experience. A single TCP port should be enabled in your ingress controller to allow this.

## Configuring GreenOps

### Security
All agents and servers are fully configured with secure authorized keys. Unknown hosts attempting to access the TCP port will be denied instantly.

### Port Configuration


GreenOps provides a secure TCP proxy service for managing Argo instances. The service is called `jumpserver`, it is in the `greenops` namespace. The pod uses the port `22`, but the service can be configured to use another port (which will then point to 22).

Only the GreenOps agents connect to this service. This is to create a tunnel and proxy Argo to the cluster where the control plane is hosted.

By default, port 22 is used. If you would like to configure another port number, set the new port in the GreenOps Helm chart by setting the variable `common.server.tunnelingPort`. For example, if a user wanted to expose TCP on port `1234`, they would make the ingress-specific changes described below and add the following flag when deploying the GreenOps control plane Helm chart: `--set 'common.server.tunnelingPort=\"1234\"'`.

### Where is Argo Exposed?
There is generally a 1-1 mapping between clusters registered in GreenOps and Argo servers. Once the proxy connection is established, the Argo services will be available locally from the control plane via a Kubernetes service. For example, if there is a cluster called `example`, there will be a service called `example` created which provides access to Argo. Port `5000` is for Argo CD, and port `5001` is for Argo Workflows. Ingress should be attached to these services to expose them outside of the cluster/embed them in the GreenOps UI.

## Using GKE Ingress

This [GCP guide](https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balancing) walks through configuring a TCP load balancer in GKE. There is a GreenOps service called `jumpserver` in the `greenops` namespace. Update this service to be a LoadBalancer. The container port is `22`, but any port can be exposed by the service. Both internal load balancers (great for VPCs) and external load balancers are supported.

## Using NGINX Community Edition
Apply the `tcp-configuration.yaml` file in this repository to the namespace where the ingress controller is deployed:
```
kubectl apply -f tcp-configuration.yaml -n <INGRESS_NAMESPACE>
```

Update the controller deployment to include this flag: `--tcp-services-configmap` in the arguments section. It is used to point towards the ConfigMap that was just created and add TCP port 22 to your ingress configuration. An example is:
```
--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
```
***Note:*** *Do not update `$(POD_NAMESPACE)`. That is meant to be a dynamic variable.*

This will point all TCP traffic to GreenOps servers, so GreenOps can connect all your Argo instances.

### Port Configuration
Any port can be configured for TCP. In the example, it is `22: "greenops/jumpserver:22"`. The port on the left (which is what is exposed by Ingress) can be updated to be anything. Remember to set the new port number in the GreenOps Helm chart by setting the variable `common.server.tunnelingPort`. For example, if a user wanted to expose TCP on port `1234`, they would set the ConfigMap to be `1234: "greenops/jumpserver:22"`, and add the following flag when deploying the GreenOps control plane Helm chart: `--set 'common.server.tunnelingPort=\"1234\"'`.

Remember to also add the port into the Ingress' Service. Full description of configuring Ingress is here: https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/

*Note*: The escape character and quotes are important when setting the variable using CLI.
