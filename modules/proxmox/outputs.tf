output "nodes" {
  description = "Information about Proxmox nodes"
  value = {
    for node_name, node_data in data.proxmox_virtual_environment_node.nodes : node_name => {
      cpu_count    = node_data.cpu_count
      cpu_model    = node_data.cpu_model
      cpu_sockets  = node_data.cpu_sockets
      memory_total = node_data.memory_total
    }
  }
}

output "pci_gpu_mapping" {
  description = "PCI GPU mapping for each node"
  value = {
    for node_name, gpu_mapping in proxmox_virtual_environment_hardware_mapping_pci.gpu : node_name => gpu_mapping.name
  }
}

output "pve_cluster" {
  description = "Proxmox cluster information"
  value = {
    cluster_name = var.cluster_name
    nodes = {
      for node_name, node_config in var.proxmox_nodes : node_name => {
        datastore = node_config.datastore
        features  = node_config.features
        ip        = node_config.ip
        web_port  = var.web_port
      }
    }
  }
}

output "pve_cluster_name" {
  description = "Proxmox cluster name"
  value       = var.cluster_name
}

output "pve_host" {
  description = "Proxmox host FQDN"
  value       = values(var.proxmox_nodes)[0].fqdn
}

output "pve_insecure" {
  description = "Whether to skip TLS verification"
  value       = false
}

output "pve_port" {
  description = "Proxmox web interface port"
  value       = var.web_port
}

output "ubuntu_image" {
  description = "Ubuntu OS image information"
  value = {
    for node_name, image in proxmox_virtual_environment_download_file.ubuntu_os_image : node_name => {
      content_type = image.content_type
      datastore    = image.datastore_id
      file_name    = image.file_name
      id           = image.id
    }
  }
}

output "ubuntu_vm_image" {
  description = "Ubuntu VM image information"
  value = {
    for node_name, image in proxmox_virtual_environment_download_file.ubuntu_vm_image : node_name => {
      content_type = image.content_type
      datastore    = image.datastore_id
      file_name    = image.file_name
      id           = image.id
    }
  }
}

output "ccm_token" {
  description = "CCM user token value"
  value       = proxmox_virtual_environment_user_token.ccm.value
  sensitive   = true
}

output "csi_token" {
  description = "CSI user token value"
  value       = proxmox_virtual_environment_user_token.csi.value
  sensitive   = true
}
