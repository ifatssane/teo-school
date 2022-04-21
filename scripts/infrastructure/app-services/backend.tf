terraform {
  backend "azurerm" {
    resource_group_name  = "jaouad-aks-dockercoins"
    storage_account_name = "dockercoinsstorage"
    container_name       = "terraform-app-services"
    key                  = "terraform.tfstate"
  }
}