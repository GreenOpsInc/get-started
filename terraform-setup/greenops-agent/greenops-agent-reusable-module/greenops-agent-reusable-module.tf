data "kubernetes_secret" "greenops_apikey_secret" {
  metadata {
    name = "greenops-apikey-secret"
    namespace = "greenops"
  }
}

resource "greenops_cluster" "greenops_cluster" {
  name = "cluster-3"
}

resource "kubernetes_secret" "greenops_apikey_secret" {
  metadata {
    name = "greenops-apikey-secret"
    namespace = "greenops"
  }

  data = {
    # If the key does not need to be rotated (var.rotate_token == false) and the greenops_apikey_secret secret exists, that means that the key has already been created and should not change.
    # If these conditions are violated, it means that the secret either needs to be rotated or created for the first time. The data from the API request will be used.
    apikey = var.rotate_token || data.kubernetes_secret.greenops_apikey_secret.data == null ? resource.greenops_cluster.greenops_cluster.apikey : data.kubernetes_secret.greenops_apikey_secret.data.apikey
  }
  type = "Opaque"
}

resource "helm_release" "greenops_daemon" {
  name       = var.greenops_agent_installation_name
  namespace  = "greenops"
  repository = "https://greenopsinc.github.io/charts"

  chart   = "greenops-daemon"
  version = var.greenops_agent_installation_version
  recreate_pods = var.rotate_token

  set {
    name  = "common.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "common.greenopsServer.url"
    value = var.greenops_url
  }

  set {
    name  = "common.commandDelegator.url"
    value = var.greenops_url
  }

  set {
    name  = "common.argo.workflows.url"
    value = var.argo_workflows_url
  }
}
