locals {
  name = "jellyfin"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = local.name
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

locals {
  values = {
    image = {
      tag = var.jellyfin_image_tag
    }

    nodeSelector = local.node_selector
    tolerations  = local.tolerations

    deploymentStrategy = {
      type = "Recreate"
    }

    ingress = {
      enabled = true
      hosts = [
        {
          host = local.host
          paths = [
            {
              path     = "/"
              pathType = "ImplementationSpecific"
            }
          ]
        }
      ]
      tls = [
        {
          secretName = "${local.host}-tls-secret"
          hosts      = [local.host]
        }
      ]
      annotations = {
        "cert-manager.io/cluster-issuer" = var.issuer
      }
    }

    initContainers = [
      {
        args = [
          <<-EOT
            echo "Setting permissions to 770 on data directory [/config] ..."
            if chmod 770 /config; then
              echo "Successfully set permissions on data directory [/config]"
            else
              echo "Failed to set permissions on data directory [/config]"
            fi
            echo "Setting ownership to 2244:2244 on data directory [/config] ..."
            if chown 2244:2244 /config; then
              echo "Successfully set ownership on data directory [/config]"
            else
              echo "Failed to set ownership on data directory [/config]"
            fi
            echo "Finished."
          EOT
        ]
        command = ["/bin/sh", "-c"]
        image   = "alpine:latest"
        name    = "fix-config-permissions"
        securityContext = {
          runAsGroup = 0
          runAsUser  = 0
        }
        volumeMounts = [
          {
            mountPath = "/config"
            name      = "config"
          }
        ]
      }
    ]

    metrics = {
      enabled = var.metrics_enabled
      serviceMonitor = {
        enabled = var.metrics_enabled
      }
    }

    persistence = {
      config = {
        size         = var.config_storage_size
        storageClass = null
      }
      media = {
        enabled = false
      }
    }

    podSecurityContext = {
      fsGroup            = 2244
      runAsGroup         = 2244
      runAsUser          = 2244
      supplementalGroups = [44, 992]
    }

    securityContext = {
      allowPrivilegeEscalation = true
      capabilities = {
        add = ["SYS_ADMIN", "SYS_RAWIO"]
      }
      privileged             = true
      readOnlyRootFilesystem = false
    }

    volumeMounts = [
      {
        mountPath = "/dev/dri"
        name      = "render"
        readOnly  = true
      },
      {
        mountPath = "/shared"
        name      = "shared"
      }
    ]
    volumes = [
      {
        name = "render"
        hostPath = {
          path = "/dev/dri"
          type = "Directory"
        }
      },
      {
        name = "shared"
        nfs = {
          path     = "/mnt/tank1/media"
          readOnly = false
          server   = var.nfs_server
        }
      }
    ]
  }
}

resource "helm_release" "jellyfin" {
  name       = local.name
  namespace  = local.namespace
  chart      = "jellyfin"
  repository = "https://jellyfin.github.io/jellyfin-helm"
  version    = var.chart_version
  atomic     = var.helm_atomic_release
  timeout    = var.helm_timeout

  values = [yamlencode(local.values)]
}
