locals {
  workloads = "${get_repo_root()}/workloads"
  env = path_relative_to_include()

  # Load users from SOPS encrypted file
  users_data = yamldecode(sops_decrypt_file("${local.workloads}/environment/${local.env}/secrets.sops.yaml"))
}

inputs = {
  users = local.users_data.users
}
