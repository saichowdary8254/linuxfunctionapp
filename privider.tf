# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.61.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "github-actions"  
    storage_account_name = "githubremotebackend"                      
    container_name       = "test-container"                       
    key                  = "terraform.tfstate"       
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

  subscription_id = "bad976a3-efdf-4d47-b37c-2eaf2b10b6ec"
}
