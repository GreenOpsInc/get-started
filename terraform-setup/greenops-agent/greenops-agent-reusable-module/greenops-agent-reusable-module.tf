data "http" "get_token" {
  url = "https://${var.greenops_url}/api/cluster/org/${var.cluster_name}/apikeys/generate"
  method = "POST"
  request_headers = {
    "x-api-key" = "${var.greenops_api_key}"
  }
}

resource "kubernetes_secret" "greenops_apikey_secret" {
  metadata {
    name = "greenops-apikey-secret"
    namespace = "greenops"
  }

  data = {
    apikey = jsondecode(data.http.get_token.response_body).apiKey
  }
  type = "Opaque"
}

resource "helm_release" "greenops_daemon" {
  name       = var.greenops_agent_installation_name
  namespace  = "greenops"
  repository = "https://greenopsinc.github.io/charts"

  chart   = "greenops-daemon"
  version = var.greenops_agent_installation_version

  set {
    name  = "common.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "common.greenopsServer.url"
    value = var.greenops_url
  }

  set {
    name  = "common.argo.workflows.url"
    value = var.argo_workflows_url
  }
}
