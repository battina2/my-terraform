provider "azurerm" {
      features = {}
}

# resource Group creation

resource "azurerm_resource_group" "rg" {
  name = "myResourceGroup"
  location = "East us"
}
# Virtual network

resource "azurerm_virtual_network" "vnet"{
  name = "myVnet"
  address_space = [10.10.10.0/16]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# subnet
resource "azurerm_subnet" "subnet" {
  name = "muSubnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_prefixes = [10.10.10.0/24]
  virtual_network_name = azurerm_virtual_network.vnet.name

}
#key Vault
 resource "azurerm_key_vault" "keyvault" {
   name                       = "myKeyvault"
   location                   = "east us"
   resource_group_name        = azurerm_resource_group.rg.name
   sku_name                   = "standard"
   tenant_id                  = data.azurerm_client_config.current.tenant_id
   soft_delete_retention_days = 7
   purge_protection_enabled   = false
   access_policy {
     tenant_id = data.azurerm_client_config.current.tenant_id
     object_id = data.azurerm_client_config.current.object_id

     secret_permissions = [
       "get",
       "list",
     ]
   }
 }
# Secret in Key Vault
resource "azurerm_key_vault_secret" "secret" {
  name         = "mySecret"
  value        = "SuperSecretValue123"
  key_vault_id = azurerm_key_vault.keyvault.id
}

# Virtual Machine
resource "azurerm_virtual_machine" "myvm" {
  name = "myvm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size = "standard_DS1_v2"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    sku = "2019-datacenter"
    version = latest
  }storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "SuperSecretPassword123"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# VM Availability Set
resource "azurerm_virtual_machine_availability_set" "vm_availability_set" {
  name                = "myAvailabilitySet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Aligned"
  platform_fault_domain_count = 2
}
