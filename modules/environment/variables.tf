variable "base_domain" {
  type        = string
  description = "The base domain for the environment"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "groups" {
  type        = list(string)
  description = "The groups to create"
}

variable "users" {
  type = list(object({
    username        = string
    display_name    = string
    first_name      = string
    last_name       = string
    email           = string
    groups          = list(string)
    create_password = bool
  }))
  description = "The users to create"
}

variable "cluster_issuer" {
  type        = string
  description = "The cluster issuer to use"
}

variable "nfs_server" {
  type        = string
  description = "The NFS server address"
}
