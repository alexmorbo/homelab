variable "repo" {
  type = string

  default = "ghcr.io/alexmorbo/dell_idrac_fan_controller"
}

variable "tag" {
  type = string

  default = "v0.1.6-1"
}

variable "dell_servers" {
  type = map(object({
    host                            = string
    user                            = string
    pass                            = string
    fan_speed                       = string
    temp_threshold                  = string
    check_interval                  = string
    disable_thirdparty_pcie_cooling = bool
  }))
}
