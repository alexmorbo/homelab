# Homelab Infrastructure

A comprehensive homelab infrastructure project built with Terraform and Terragrunt, featuring Proxmox virtualization, Talos Linux, and Kubernetes orchestration.

## 🏗️ Architecture Overview

This project manages a complete homelab infrastructure stack:

- **Proxmox VE**: Hypervisor for VM management and PCI passthrough
- **Talos Linux**: Immutable Linux distribution for Kubernetes nodes
- **Kubernetes**: Container orchestration platform
- **Infrastructure as Code**: Everything managed through Terraform/Terragrunt

## 📁 Project Structure

```
homelab/
├── modules/                    # Reusable Terraform modules
│   └── proxmox/               # Proxmox infrastructure module
├── providers/                  # Terraform provider configurations
│   ├── terraform.tf           # Terraform version requirements
│   ├── proxmox.tf             # Proxmox provider
│   ├── kubernetes.tf          # Kubernetes provider
│   ├── talos.tf               # Talos Linux provider
│   └── ...                    # Other provider configs
├── workloads/                  # Environment-specific configurations
│   ├── proxmox/               # Proxmox infrastructure
│   │   ├── main.tfvars        # Proxmox configuration
│   │   └── terragrunt.hcl     # Terragrunt configuration
│   └── kubernetes/            # Kubernetes clusters
│       ├── <environment>/     # Cluster environment (e.g., alpha, beta, prod)
│       │   ├── main.tfvars    # Cluster configuration
│       │   └── terragrunt.hcl # Terragrunt configuration
│       └── meta.yaml          # Cluster metadata
├── main.hcl                   # Root Terragrunt configuration
└── secrets.sops.yaml          # Encrypted secrets (SOPS)
```

## 🚀 Getting Started

### Prerequisites

- **Terraform**: >= 1.0
- **Terragrunt**: Latest version
- **SOPS**: For secrets management
- **Pre-commit hooks**: For code quality

### Installation

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd homelab
   ```

2. **Install pre-commit hooks**:
   ```bash
   pre-commit install
   ```

3. **Configure secrets**:
   - Create `secrets.sops.yaml` with your configuration
   - Update with your actual values
   - Encrypt using SOPS

### Running Pre-commit

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run terraform_tflint
```

## 🏠 Infrastructure Components

### Proxmox Infrastructure

Located in `workloads/proxmox/`, this manages:

- **Proxmox nodes**: Host configuration with IPs, FQDNs, and features
- **PCI passthrough**: GPU and hardware device mappings
- **Datastores**: Storage configuration for VMs

**Example configuration**:
```hcl
proxmox_nodes = {
  "node-1" = {
    ip   = "10.90.11.21"
    fqdn = "node-1.homelab.local"
    features = {
      pihole = true
    }
    datastore = "fast4"
  }
}
```

### Kubernetes Clusters

Located in `workloads/kubernetes/`, this manages:

- **Talos Linux nodes**: Immutable Linux for Kubernetes
- **Control plane**: High-availability control plane nodes
- **Worker nodes**: Different node types (ingress, default, infra, media, monitoring)
- **Network configuration**: VLANs, subnets, and routing

**Node types**:
- **ingress**: Load balancer and ingress controllers
- **default**: General purpose workloads
- **infra**: Infrastructure services
- **media**: Media processing with GPU passthrough
- **monitoring**: Observability stack
- **through-vpn**: VPN-routed workloads

**Example cluster configuration**:
```hcl
cluster_name = "alpha"
kubernetes_version = "1.33.0"
talos_cp_version = "1.10.0"

controlplanes = {
  "node-1" = {
    count = 3
    networks = [
      {
        interface = "eth0"
        bridge    = "vmbr0"
        tag       = 12
      }
    ]
  }
}
```

## 🔧 Modules

### Proxmox Module (`modules/proxmox/`)

Provides reusable Proxmox infrastructure components:

- **Node management**: IP, FQDN, feature flags
- **PCI passthrough**: Hardware device mapping
- **Cluster configuration**: Proxmox cluster settings

## 🌐 Network Architecture

The infrastructure uses a segmented network approach:

- **VLAN 12**: Main VM network (10.90.12.0/24)
- **VLAN 19**: IoT network for smart devices and isolated workloads
- **Pod network**: 10.209.0.0/16
- **Service network**: 10.208.0.0/16

## 🔐 Security

- **SOPS encryption**: Secrets are encrypted using SOPS
- **Network segmentation**: VLANs isolate different workload types
- **Immutable infrastructure**: Talos Linux provides secure base images

## 📋 Development Workflow

1. **Make changes** to configuration files
2. **Run pre-commit** to ensure code quality
3. **Plan changes** with Terragrunt
4. **Apply changes** to infrastructure
5. **Commit and push** changes

### Common Commands

```bash
# Plan changes
cd workloads/proxmox
terragrunt plan

# Apply changes
terragrunt apply

# Destroy infrastructure
terragrunt destroy

# Update dependencies
terragrunt init --upgrade
```

## 🧪 Testing

- **TFLint**: Terraform linting and validation
- **terraform fmt**: Code formatting
- **Pre-commit hooks**: Automated quality checks

## 📚 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Talos Linux Documentation](https://www.talos.dev/)
- [Proxmox VE Documentation](https://pve.proxmox.com/wiki/Main_Page)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
