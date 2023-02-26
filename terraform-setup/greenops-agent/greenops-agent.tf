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
