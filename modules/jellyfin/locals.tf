locals {
  namespace = kubernetes_namespace.default.metadata[0].name
  host      = "jelly.${var.base_domain}"

  tolerations = var.dedicated_nodes ? [
    {
      key    = "node.home.lab/dedicated"
      value  = var.dedicated_node_group
      effect = "NoExecute"
    }
  ] : []

  node_selector = var.dedicated_nodes ? {
    "node.home.lab/group" = var.dedicated_node_group
  } : {}
}
