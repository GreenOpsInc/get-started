variable "greenops_agent_installation_name" {
  type    = string
  default = "greenops-daemon"
}

variable "greenops_agent_installation_version" {
  type    = string
  default = "1.0.0"
}

variable "greenops_url" {
  type    = string
  default = "hz.greenops.io"
}

variable "argo_workflows_url" {
  type    = string
  default = "argoworkflows2.greenops.io"
}

variable "greenops_api_key" {
  type    = string
  sensitive = true
}

variable "cluster_name" {
  type = string
  default = "test-agent"
}
