terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.93.0"
      skip_provider_registration = true
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}


resource "azurerm_storage_account" "lab" {
  name                     = "newfileandblob4lab"
  resource_group_name      = "Enter Resource Group Name"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lab" {
  name                  = "blobcontainer4lab"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "lab" {
  name                   = "TerraformBlob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block"
}
resource "azurerm_storage_share" "lab" {
  name                 = "terraformshare"
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
}