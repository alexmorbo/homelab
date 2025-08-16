# Get information about specific Proxmox nodes
data "proxmox_virtual_environment_node" "nodes" {
  for_each = var.proxmox_nodes

  node_name = each.key
}

# Create kubernetes user
resource "proxmox_virtual_environment_user" "kubernetes" {
  user_id = "kubernetes@pve"
  comment = "Kubernetes"
  enabled = true

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.ccm.role_id
  }

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }
}

# Create CCM role for Cloud Controller Manager
resource "proxmox_virtual_environment_role" "ccm" {
  role_id = "CCM"
  privileges = [
    "VM.Audit"
  ]
}

# Create CSI role for Container Storage Interface
resource "proxmox_virtual_environment_role" "csi" {
  role_id = "CSI"
  privileges = [
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit",
    "VM.Audit",
    "VM.Config.Disk"
  ]
}

# Create CCM ACL
resource "proxmox_virtual_environment_acl" "ccm" {
  path      = "/"
  propagate = true
  role_id   = proxmox_virtual_environment_role.ccm.role_id
  token_id  = proxmox_virtual_environment_user_token.ccm.id
}

# Create CSI ACL
resource "proxmox_virtual_environment_acl" "csi" {
  path      = "/"
  propagate = true
  role_id   = proxmox_virtual_environment_role.csi.role_id
  token_id  = proxmox_virtual_environment_user_token.csi.id
}

# Create CCM user token
resource "proxmox_virtual_environment_user_token" "ccm" {
  user_id               = proxmox_virtual_environment_user.kubernetes.user_id
  token_name            = "ccm"
  comment               = "Kubernetes CCM"
  privileges_separation = true
}

# Create CSI user token
resource "proxmox_virtual_environment_user_token" "csi" {
  user_id               = proxmox_virtual_environment_user.kubernetes.user_id
  token_name            = "csi"
  comment               = "Kubernetes CSI"
  privileges_separation = true
}

# Download Ubuntu OS image for containers
resource "proxmox_virtual_environment_download_file" "ubuntu_os_image" {
  for_each = var.proxmox_nodes

  content_type   = "vztmpl"
  datastore_id   = each.value.datastore
  file_name      = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  node_name      = each.key
  url            = "http://download.proxmox.com/images/system/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  verify         = true
  overwrite      = false
  upload_timeout = 600
}

# Download Ubuntu VM image
resource "proxmox_virtual_environment_download_file" "ubuntu_vm_image" {
  for_each = var.proxmox_nodes

  content_type   = "iso"
  datastore_id   = each.value.datastore
  file_name      = "noble-server-cloudimg-amd64.img"
  node_name      = each.key
  url            = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  verify         = true
  overwrite      = false
  upload_timeout = 600
}

# Hardware mapping for PCI devices (GPU)
resource "proxmox_virtual_environment_hardware_mapping_pci" "gpu" {
  for_each = var.pci_mappings

  name             = each.value.name
  comment          = each.value.comment
  mediated_devices = each.value.mediated_devices

  map = [
    for device in each.value.devices : {
      id           = device.id
      path         = device.path
      node         = each.key
      iommu_group  = device.iommu_group
      subsystem_id = device.subsystem_id
      comment      = device.comment
    }
  ]
}
