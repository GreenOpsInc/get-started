variable "greenops_license" {
  type    = string
  sensitive = true
}

variable "greenops_installation_name" {
  type    = string
  default = "greenops"
}

variable "greenops_installation_version" {
  type    = string
  default = "1.0.0"
}

variable "greenops_url" {
  type    = string
}
