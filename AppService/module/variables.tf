variable "environment" {
  type = string
}

variable "namespace"{
  type = string
}

variable "service_name" {
    type = string
}

variable "image" {
    type = string
}

locals {
    registry_path           = "registry_path"
    resource_group_name     = "resource_group_name"
    appsettingsname         = "applicationsettings"
    aadpodidbinding_name    = "promotion-api-identity"
}
