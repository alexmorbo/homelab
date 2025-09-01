terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.16.0, < 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.33.0"
    }
  }
  required_version = ">= 0.15"
}
