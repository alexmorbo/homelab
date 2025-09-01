locals {
  name = "dell-temperature"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = local.name
  }
}

locals {
  namespace = kubernetes_namespace.default.metadata[0].name
}

resource "kubernetes_secret" "default" {
  for_each = var.dell_servers

  metadata {
    name      = "fan-controller-${each.key}"
    namespace = local.namespace
  }

  data = {
    "IDRAC_HOST"                                                  = each.value.host,
    "IDRAC_USERNAME"                                              = each.value.user,
    "IDRAC_PASSWORD"                                              = each.value.pass,
    "FAN_SPEED"                                                   = each.value.fan_speed,
    "CPU_TEMPERATURE_THRESHOLD"                                   = each.value.temp_threshold,
    "CHECK_INTERVAL"                                              = each.value.check_interval,
    "DISABLE_THIRD_PARTY_PCIE_CARD_DELL_DEFAULT_COOLING_RESPONSE" = each.value.disable_thirdparty_pcie_cooling,
    "KEEP_THIRD_PARTY_PCIE_CARD_COOLING_RESPONSE_STATE_ON_EXIT"   = true
  }
}

resource "kubernetes_deployment" "default" {
  for_each = var.dell_servers

  metadata {
    name      = "fan-controller-${each.key}"
    namespace = local.namespace
    labels = {
      "fan.host"    = each.value.host
      "config-hash" = sha1(join(" ", [for v in each.value : v]))
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "fan.host" = each.value.host
      }
    }

    template {
      metadata {
        labels = {
          "fan.host"    = each.value.host
          "config-hash" = sha1(join(" ", [for v in each.value : v]))
        }
      }

      spec {
        node_selector = {
          "node-role.kubernetes.io/control-plane" = ""
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node-role.kubernetes.io/control-plane"
                  operator = "Exists"
                }
              }
            }
          }
        }

        toleration {
          key    = "node-role.kubernetes.io/control-plane"
          effect = "NoSchedule"
        }

        container {
          image = "${var.repo}:${var.tag}"
          name  = "controller"
          env_from {
            secret_ref {
              name = kubernetes_secret.default[each.key].metadata[0].name
            }
          }
        }
      }
    }
  }
}
