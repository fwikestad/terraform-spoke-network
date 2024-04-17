terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

provider "azurerm" {
  features {}
}

/*
    Replace the susbcription_id with the subscription id for the connectivity subscription where the hub network is located
*/
provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "[uuid-for-connectivity-subscription]"
  features {}
}

data "azurerm_client_config" "core" {}

module "spoke_network" {
  source = "../../"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  hub_vnet_name                = "hub"
  hub_vnet_resource_group_name = "hub-rg"
  vnet_address_space           = ["10.0.0.0/8"]
  vnet_dns_servers = []
  subnets = {
    "snet-01" = {
      address_prefix = "10.0.1.0/24"
    }
    "snet-02" = {
      address_prefix = "10.11.2.0/24"
    }
  }
}