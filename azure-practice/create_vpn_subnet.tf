terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "= 2.99"
    }
  }
}

#provider "azurerm" {
 # features {}

  #skip_provider_registration = true
#}

# Create virtual network
resource "azurerm_virtual_network" "TFNet" {
  name                = "LabVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "Enter Resource Group Name"

  tags = {
    environment = "Terraform Networking"
  }
}

# Create subnet
resource "azurerm_subnet" "tfsubnet" {
  name                 = "LabSubnet"
  resource_group_name = "Enter Resource Group Name"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes       = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "tfsubnet2" {
  name                 = "LabSubnet2"
  resource_group_name = "Enter Resource Group Name"
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes       = ["10.0.2.0/24"]
}