terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.57.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
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

resource "azurerm_resource_group" "aks" {
  name     = "aks-rg"
  location = "West US"
  }

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.1.0"
  vnet_location       = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.52.0.0/24", "10.52.1.0/24", "10.52.2.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  vnet_name           = "aks-vnet"
  use_for_each        = true
  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group.aks]
}
