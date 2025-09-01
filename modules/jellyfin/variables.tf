variable "base_domain" {
  type = string
}

variable "nfs_server" {
  type = string
}

variable "dedicated_nodes" {
  type    = bool
  default = false
}

variable "dedicated_node_group" {
  type    = string
  default = ""
}

variable "issuer" {
  type    = string
  default = null
}

variable "jellyfin_image_tag" {
  type    = string
  default = null
}

variable "config_storage_size" {
  type    = string
  default = "10Gi"
}

variable "chart_version" {
  type    = string
  default = "2.3.0"
}

variable "helm_atomic_release" {
  type    = bool
  default = false
}

variable "helm_timeout" {
  type    = string
  default = "300"
}

variable "metrics_enabled" {
  type    = bool
  default = true
}
