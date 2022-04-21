terraform {
  backend "azurerm" {
    resource_group_name  = "jaouad-aks-dockercoins"
    storage_account_name = "jaouadterraformstorage"
    container_name       = "jaouad-terraform-container"
    key                  = "terraform.tfstate"
  }
}