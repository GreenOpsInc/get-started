terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.17.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }

    http = {
      source = "hashicorp/http"
      version = "3.2.1"
    }
  }
}
