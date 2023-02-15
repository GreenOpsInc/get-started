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

module "greenops-agent" {
  source = "./greenops-agent-reusable-module"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
  cluster_name = var.cluster_name
  greenops_url = var.greenops_url
  argo_workflows_url = var.argo_workflows_url
  greenops_api_key = var.greenops_api_key
}
