terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.57.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}
provider "azurerm" {
  features {}

}

provider "kubectl" {
  host                   = module.aks.cluster_fqdn
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = module.aks.cluster_fqdn
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

  }
}

# Resource Group
resource "azurerm_resource_group" "aks" {
  name     = "aks-rg"
  location = "West US"
}

resource "azurerm_virtual_network" "aks" {
  name                = "vnet-aks"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  address_space       = ["10.52.0.0/16"]
}

resource "azurerm_subnet" "prod" {
  name                     = "subnet-prod"
  virtual_network_name     = azurerm_virtual_network.aks.name
  resource_group_name      = azurerm_resource_group.aks.name
  address_prefixes         = ["10.52.1.0/24"]
}

resource "azurerm_subnet" "db" {
  name                     = "db-network"
  virtual_network_name     = azurerm_virtual_network.aks.name
  resource_group_name      = azurerm_resource_group.aks.name
  address_prefixes         = ["10.52.2.0/24"]
}
