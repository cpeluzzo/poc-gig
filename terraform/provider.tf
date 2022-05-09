terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.83.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
 
  backend "azurerm" {
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
