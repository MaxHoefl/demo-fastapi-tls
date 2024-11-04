terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.94.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

## Resource Group (uncomment if not exists)
#resource "azurerm_resource_group" "rg" {
#  name     = "demo-rg"
#  location = "germanywestcentral"
#}

# Log Analytics Workspace (required for Container App Environment)
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "demo-workspace"
  resource_group_name = "demo-rg"
  location            = "germanywestcentral"
  sku                 = "PerGB2018"  # This is the default and most cost-effective pricing tier

  retention_in_days = 30  # Shorter retention to reduce costs
}

# Container App Environment
resource "azurerm_container_app_environment" "app_env" {
  name                 = "demo-environment"
  resource_group_name  = "demo-rg"
  location             = "germanywestcentral"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  # Setting up internal-only access for reduced exposure and cost savings
#  internal_only = true
}

resource "azurerm_container_app" "demo-app" {
  name                         = "demo-app"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = "demo-rg"
  revision_mode                = "Single"

  secret {
    name  = "acr-password"
    value = var.acr_password
  }

  registry {
    server               = var.acr_server
    username             = var.acr_username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "demo-api"
      image  = "${var.acr_server}/demo-api:8dbc059dab9fd9379c26bf9fe5dce6e8ca02bb77"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}