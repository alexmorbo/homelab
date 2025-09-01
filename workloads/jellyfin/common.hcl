locals {
  workloads = "${get_repo_root()}/workloads"
  env = path_relative_to_include()
}

dependency "kubernetes" {config_path = "${local.workloads}/kubernetes/${local.env}"}
dependency "environment" {config_path = "${local.workloads}/environment/${local.env}"}
dependency "certmanager" {config_path = "${local.workloads}/cert-manager/${local.env}"}

inputs = {
  kubernetes_host                   = dependency.kubernetes.outputs.kubeconfig.host
  kubernetes_cluster_ca_certificate = base64decode(dependency.kubernetes.outputs.kubeconfig.ca_certificate)
  kubernetes_client_certificate     = base64decode(dependency.kubernetes.outputs.kubeconfig.client_certificate)
  kubernetes_client_key             = base64decode(dependency.kubernetes.outputs.kubeconfig.client_key)

  base_domain = dependency.environment.outputs.base_domain
  timezone    = dependency.environment.outputs.timezone
  nfs_server  = dependency.environment.outputs.nfs_server

  issuer = dependency.certmanager.outputs.cluster_issuers[dependency.environment.outputs.cluster_issuer]
}
