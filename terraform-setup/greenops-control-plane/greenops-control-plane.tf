provider "kubernetes" {
  # Configure K8S access
  ...
}

provider "helm" {
  kubernetes {
    # Configure K8S access
    ...
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

  #values = [
  #  "${file("values.yaml")}"
  #]

  set {
    name  = "common.server.greenopsUrl"
    value = var.greenops_url
  }
}
