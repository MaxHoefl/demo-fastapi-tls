provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = "Germany Central"
}

# Log Analytics Workspace (required for Container App Environment)
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "demo-workspace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"  # This is the default and most cost-effective pricing tier

  retention_in_days = 7  # Shorter retention to reduce costs
}

# Container App Environment
resource "azurerm_container_app_environment" "app_env" {
  name                 = "demo-environment"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  # Setting up internal-only access for reduced exposure and cost savings
  internal_only = true
}

resource "azurerm_container_app" "demo-app" {
  name                         = "demo-app"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "demo-app"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}