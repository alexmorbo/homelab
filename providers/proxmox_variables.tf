variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "proxmox_insecure" {
  type    = bool
  default = false
}

variable "proxmox_ssh_username" {
  type = string
}

variable "proxmox_ssh_password" {
  type = string
}
