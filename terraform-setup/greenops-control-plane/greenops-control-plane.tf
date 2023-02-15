provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_greenops-dev_us-central1-c_cluster-2"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "gke_greenops-dev_us-central1-c_cluster-2"
  }
}

resource "kubernetes_secret" "greenops_license" {
  metadata {
    name = "greenops-license"
    namespace = "greenops"
  }

  data = {
    license = var.greenops_license
  }
  type = "Opaque"
}

resource "helm_release" "greenops_control_plane" {
  name       = var.greenops_installation_name
  namespace  = "greenops"
  repository = "https://greenopsinc.github.io/charts"

  chart   = "greenops"
  version = var.greenops_installation_version

  set {
    name  = "common.server.greenopsUrl"
    value = var.greenops_url
  }
}
