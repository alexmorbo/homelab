locals {
  workloads = "${get_repo_root()}/workloads"
  env = path_relative_to_include()
}

dependency "kubernetes" {config_path = "${local.workloads}/kubernetes/${local.env}"}

inputs = {
  kubernetes_host                   = dependency.kubernetes.outputs.kubeconfig.host
  kubernetes_cluster_ca_certificate = base64decode(dependency.kubernetes.outputs.kubeconfig.ca_certificate)
  kubernetes_client_certificate     = base64decode(dependency.kubernetes.outputs.kubeconfig.client_certificate)
  kubernetes_client_key             = base64decode(dependency.kubernetes.outputs.kubeconfig.client_key)
}
