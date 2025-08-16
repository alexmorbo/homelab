variable "proxmox_nodes" {
  type = map(object({
    ip        = string
    fqdn      = string
    features  = optional(map(bool), {})
    datastore = string
  }))
  description = "Proxmox nodes configuration with IP, FQDN, features, and datastore"
  default     = {}
}



variable "cluster_name" {
  type        = string
  description = "Proxmox cluster name"
  default     = "homelab"
}

variable "web_port" {
  type        = number
  description = "Proxmox web interface port"
  default     = 8006
}

variable "pci_mappings" {
  type = map(object({
    name             = string
    comment          = optional(string, "Managed by Terraform")
    mediated_devices = optional(bool, false)
    devices = list(object({
      id           = string
      path         = string
      iommu_group  = number
      subsystem_id = string
      comment      = optional(string, "Managed by Terraform")
    }))
  }))
  description = "PCI hardware mappings for each node"
  default     = {}
}
