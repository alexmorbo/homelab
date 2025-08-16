terraform_binary = "terraform"

locals {
  path_parts = split("/", path_relative_to_include())
  base_module_path = "${get_repo_root()}/modules"

  workload = local.path_parts[1]
  module = try(local.path_parts[2], "")
  env = try(local.path_parts[3], "")

  default_meta = {
    source = join("/", compact(["modules", local.workload, local.module]))
    providers = []
  }

  parent_meta_file = join("/", [dirname(path_relative_to_include()), "meta.yaml"])
  meta_file = join("/", [path_relative_to_include(), "meta.yaml"])
  meta_code = try(file(local.meta_file), try(file(local.parent_meta_file), "{}"))
  meta = merge(local.default_meta, try(yamldecode(local.meta_code), {}))

  repo_root = get_repo_root()
  secrets = yamldecode(sops_decrypt_file("${get_repo_root()}/secrets.sops.yaml"))
}


terraform {
  source = startswith(local.meta["source"], "modules/") ? join(
    "/", [get_parent_terragrunt_dir(), local.meta["source"]]
  ) : local.meta["source"]

  extra_arguments "environment_vars" {
    commands = ["apply", "plan", "import", "refresh", "push", "destroy"]
    optional_var_files = [
      "${get_parent_terragrunt_dir()}/local.tfvars",
      "${get_parent_terragrunt_dir()}/common.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload]))}/common.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload]))}/local.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload, local.module]))}/common.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload, local.module]))}/local.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload, local.module, local.env]))}/main.tfvars",
      "${join("/", compact([get_parent_terragrunt_dir(), "workloads", local.workload, local.module, local.env]))}/local.tfvars",
    ]
  }

  extra_arguments "compact_warnings" {
    commands = ["apply", "plan"]
    arguments = ["-compact-warnings"]
  }
}

generate "backend" {
  path      = "backend.tf"
  contents  = <<-EOF
  terraform {
    backend "s3" {
      endpoints = {
        s3       = "https://storage.yandexcloud.net"
      }
      bucket                      = "homelab-terraform-states"
      region                      = "ru-central1"
      key                         = "${join("-", compact([local.workload, local.module, local.env]))}.tfstate"

      access_key                  = "${local.secrets.backend.aws_access_key_id}"
      secret_key                  = "${local.secrets.backend.aws_secret_access_key}"

      skip_region_validation      = true
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
    }
  }
  EOF
  if_exists = "overwrite"
}

generate "providers" {
  path = "providers.tf"
  contents = join("\n", concat(
    tolist(toset([for provider in local.meta["providers"] : file("providers/${provider}_variables.tf")])),
    [for provider in local.meta["providers"] : file("providers/${provider}.tf")],
  ))
  if_exists = "overwrite"
}

inputs = merge(
  {
    workload    = local.workload
    environment = local.env
  },
  local.secrets.global,
)
