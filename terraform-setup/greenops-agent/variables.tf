variable "greenops_api_key" {
  type    = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
}

variable "greenops_url" {
  type    = string
}

variable "argo_workflows_url" {
  type    = string
}
