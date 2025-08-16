proxmox_nodes = {
  "r730xd-1" = {
    ip   = "10.90.11.21"
    fqdn = "r730xd-1.morbo.dev"
    features = {
      pihole = true
    }
    datastore = "fast4"
  }
}

pci_mappings = {
  "r730xd-1" = {
    name             = "intel-arc360"
    comment          = "Managed by Terraform"
    mediated_devices = false
    devices = [
      {
        id           = "8086:4f92"
        path         = "0000:86:00.0"
        iommu_group  = 15
        subsystem_id = "1849:6006"
        comment      = "Managed by Terraform for intel-arc360 - gpu"
      },
      {
        id           = "8086:56a5"
        path         = "0000:85:00.0"
        iommu_group  = 14
        subsystem_id = "1849:6006"
        comment      = "Managed by Terraform for intel-arc360 - gpu"
      }
    ]
  }
}
