terraform {
  required_providers {
    greenops = {
      version = "~> 1.0.0"
      source  = "greenops.io/terraform-provider-greenops/greenops"
    }
  }
}

provider "kubernetes" {
  # Configure K8S access
  config_path    = "~/.kube/config"
  config_context = "gke_greenops-dev_us-central1-c_cluster-3"
}

provider "helm" {
  kubernetes {
    # Configure K8S access
    config_path    = "~/.kube/config"
    config_context = "gke_greenops-dev_us-central1-c_cluster-3"
  }
}

provider "greenops" {
  address = "https://org.greenops.io"
  org = "org"
  token = "5sIlMKxlLjoSyOLZLIwNObloG5R6Z3ZAZs95phMqjdgmj9hhYVhQ0jHkERO9Z12L"
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
  rotate_token = var.rotate_token
}
