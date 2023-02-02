terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" { 
  name     = "rg-${var.name}" 
  location = var.loc
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}"
  address_space       = [var.address]
  location            = var.loc
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnets" {
  resource_group_name = azurerm_resource_group.rg.name
  count = length(var.cidr_blocks)
  name                 = "subnet${count.index}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = [var.cidr_blocks[count.index]]
}