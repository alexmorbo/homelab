# tflint-ignore: terraform_required_providers
provider "kubernetes" {
  host                   = var.kubernetes_host
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  client_certificate     = var.kubernetes_client_certificate
  client_key             = var.kubernetes_client_key
}
