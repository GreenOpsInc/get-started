provider "kubernetes" {
  alias          = "cluster1"
  # Configure K8S access
  ...
}

provider "helm" {
  alias = "cluster1"
  kubernetes {
    # Configure K8S access
    ...
  }
}

provider "kubernetes" {
  alias          = "cluster2"
  config_path    = "~/.kube/config"
  config_context = "gke_greenops-dev_us-central1-c_cluster-2"
}

provider "helm" {
  alias = "cluster2"
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "gke_greenops-dev_us-central1-c_cluster-2"
  }
}

variable "greenops_url" {
  type    = string
}

variable "greenops_api_key" {
  type    = string
  sensitive = true
}

variable "rotate_token" {
  description = "If set to true, it will rotate the key for this cluster"
  type    = bool
}

module "greenops-agent-cluster-1" {
  source = "./../greenops-agent-reusable-module"

  providers = {
    kubernetes = kubernetes.cluster1
    helm = helm.cluster1
  }
  cluster_name = "cluster-1-exampl"
  greenops_url = var.greenops_url
  argo_workflows_url = "argoworkflows-env1.domain.com"
  greenops_api_key = var.greenops_api_key
  rotate_token = var.rotate_token
}


module "greenops-agent-cluster-2" {
  source = "./../greenops-agent-reusable-module"

  providers = {
    kubernetes = kubernetes.cluster2
    helm = helm.cluster2
  }
  cluster_name = "cluster-2-exampl"
  greenops_url = var.greenops_url
  argo_workflows_url = "argoworkflows-env2.domain.com"
  greenops_api_key = var.greenops_api_key
  rotate_token = var.rotate_token

  # HACK: For now, agents need to be installed sequentially for concurrency reasons. This is being fixed - the depends_on tag will be unecessary soon.
  depends_on = [
    module.greenops-agent-cluster-1
  ]
}
