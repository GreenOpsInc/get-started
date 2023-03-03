variable "greenops_api_key" {
  type    = string
  sensitive = true
}

variable "rotate_token" {
  description = "If set to true, it will rotate the key for this cluster"
  type    = bool
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
