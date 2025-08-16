locals {
  workloads = "${get_repo_root()}/workloads"
  env = path_relative_to_include()
}

dependency "proxmox" {config_path = "${local.workloads}/proxmox"}

inputs = {
  proxmox_cluster = dependency.proxmox.outputs.pve_cluster
}
