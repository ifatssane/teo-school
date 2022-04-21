terraform {
  backend "azurerm" {
    resource_group_name  = "jaouad-aks-dockercoins"
    storage_account_name = "dockercoinsstorage"
    container_name       = "terraform-kubernetes"
    key                  = "terraform.tfstate"
  }
}