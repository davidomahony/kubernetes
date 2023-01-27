terraform {
  backend "azurerm" {} // Thhis is needed to link to your backend state file in a storage account
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.6.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "cluster_name" // Used to log into the cluster for the deployments
}
