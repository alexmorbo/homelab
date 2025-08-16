cluster_name     = "alpha"
talos_cp_version = "1.10.0"
talos_schematic = [
  "siderolabs/i915",
  "siderolabs/intel-ucode",
  "siderolabs/mei",
  "siderolabs/qemu-guest-agent",
]

# Network Configuration
default_gateway = "10.90.12.1"
cluster_vip     = "10.90.12.11"

vm_subnet      = "10.90.12.0/24"
pod_subnet     = "10.209.0.0/16"
service_subnet = "10.208.0.0/16"

# DNS Configuration
dns = ["10.90.11.2", "10.90.11.3"]



# Control Plane Nodes
controlplanes = {
  "r730xd-1" = {
    count = 3
    networks = [
      {
        interface = "eth0"
        bridge    = "vmbr0"
        tag       = 12
      },
    ]
  }
}

# Worker Nodes
workers = {
  "r730xd-1" = {
    ingress = {
      count = 2
      cpu   = 2
      ram   = 4096
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
      ]
    }
    default = {
      count = 1
      cpu   = 4
      ram   = 8192
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
        {
          interface     = "eth1"
          bridge        = "vmbr1"
          tag           = 19
          dhcp_disabled = true
        },
      ]
    }
    infra = {
      count = 3
      cpu   = 4
      ram   = 4096
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
      ]
    }
    media = {
      count  = 1
      socket = 2
      cpu    = 4
      ram    = 32768
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
        {
          interface     = "eth1"
          bridge        = "vmbr0"
          tag           = 19
          dhcp_disabled = true
        },
      ]
      pci_passthrough = [
        {
          id     = "0000:85:00"
          pcie   = true
          rombar = true
          xvga   = true
        },
      ]
    }
    monitoring = {
      count = 1
      cpu   = 4
      ram   = 8192
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
      ]
    }
    "through-vpn" = {
      count = 2
      cpu   = 4
      ram   = 8192
      networks = [
        {
          interface = "eth0"
          bridge    = "vmbr0"
          tag       = 12
        },
        {
          interface     = "eth1"
          bridge        = "vmbr0"
          tag           = 19
          dhcp_disabled = true
        },
      ]
    }
  }
}

# Kubernetes Configuration
kubernetes_version = "1.33.0"

create_kubeconfig_file  = true
create_talosconfig_file = true
