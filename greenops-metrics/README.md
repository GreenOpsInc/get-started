## Linting

```bash
helm lint ./greenops-metrics
```

## Packaging

```bash
helm package ./greenops-metrics
```

## Installing

Base arguments:

 - `common.namespace`: Namespace (default is `greenops`)
 - `prometheus.auth.username`: Greenops metrics server username
 - `prometheus.auth.password`: Greenops metrics server password
 - `prometheus.greenopsServerUrl`: Greenops metrics server url
 - `prometheus.workflowsServerUrl`: Argo Workflows metrics server url
 - `grafana.prometheusUrl`: Prometheus URL (default is `http://prometheus-service.greenops.svc.cluster.local:9090`)

Example:

```bash
helm install greenops-metrics ./greenops-metrics-<version>.tgz \
  --set 'common.namespace=greenops' \
  --set 'prometheus.auth.username=username' \
  --set 'prometheus.auth.password=password' \
  --set 'prometheus.greenopsServerUrl=greenops-server.greenops.svc.cluster.local' \
  --set 'prometheus.workflowsServerUrl=argo-server.argo2.svc.cluster.local' \
  --set 'grafana.prometheusUrl=http://prometheus-service.greenops.svc.cluster.local:9090'
```

## Updating

Example:

```bash
helm upgrade --install greenops-metrics ./greenops-metrics-<version>.tgz \
  --set 'common.namespace=greenops' \
  --set 'prometheus.auth.username=username' \
  --set 'prometheus.auth.password=password' \
  --set 'prometheus.greenopsServerUrl=greenops-server.greenops.svc.cluster.local' \
  --set 'prometheus.workflowsServerUrl=argo-server.argo2.svc.cluster.local' \
  --set 'grafana.prometheusUrl=http://prometheus-service.greenops.svc.cluster.local:9090'
```
