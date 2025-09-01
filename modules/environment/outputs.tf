output "base_domain" {
  description = "The base domain for the environment"
  value       = var.base_domain
}

output "name" {
  description = "The environment name"
  value       = var.environment
}

output "timezone" {
  description = "The timezone for the environment"
  value       = "Europe/Moscow"
}

output "groups" {
  description = "The groups created for the environment"
  value       = var.groups
}

output "users" {
  description = "The users created for the environment"
  value       = var.users
}

output "cluster_issuer" {
  description = "The cluster issuer to use"
  value       = var.cluster_issuer
}

output "nfs_server" {
  description = "The NFS server address"
  value       = var.nfs_server
}
