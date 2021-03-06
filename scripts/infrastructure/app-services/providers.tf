provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
    local = {
      source = "hashicorp/local"
    }
    # azuredevops = {
    #   source = "microsoft/azuredevops"
    #   version = ">=0.1.0"
    # }
  }
}