# tflint-ignore: terraform_required_providers
provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure

  ssh {
    username = var.proxmox_ssh_username
    password = var.proxmox_ssh_password
  }
}
