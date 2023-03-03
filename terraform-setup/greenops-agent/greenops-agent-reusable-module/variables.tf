variable "greenops_agent_installation_name" {
  type    = string
  default = "greenops-daemon"
}

variable "greenops_agent_installation_version" {
  type    = string
  default = "1.0.0"
}

variable "rotate_token" {
  description = "If set to true, it will rotate the key for this cluster"
  type    = bool
}

variable "greenops_url" {
  type    = string
}

variable "argo_workflows_url" {
  type    = string
}

variable "greenops_api_key" {
  type    = string
  sensitive = true
}

variable "cluster_name" {
  type = string
}
