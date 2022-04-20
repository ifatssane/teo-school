resource "azurerm_service_plan" "appServiceLinux" {
    name                = "docker-coins-app-service-plan-linux"
    location            = var.location
    resource_group_name = var.resource_group_name
    os_type = "Linux"
    sku_name = "B1"
}

resource "azurerm_app_service" "webui-app-service" {
 name                    = "webui-app-service"
 location                = var.location
 resource_group_name     = var.resource_group_name
 app_service_plan_id     = azurerm_service_plan.appServiceLinux.id
 client_affinity_enabled = true
 site_config {
   scm_type  = "LocalGit"
   always_on = "true"

   linux_fx_version  = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/webui:1.276" #define the images to usecfor you application

   health_check_path = "/health" # health check required in order that internal app service plan loadbalancer do not loadbalance on instance down
 }

 identity {
   type         = "SystemAssigned"
 }

 app_settings = {
   DOCKER_REGISTRY_SERVER_URL            = var.docker_registry_server_url
   DOCKER_REGISTRY_SERVER_USERNAME       = var.docker_registry_server_username
   DOCKER_REGISTRY_SERVER_PASSWORD       = var.docker_registry_server_password
 } 
}

resource "azurerm_app_service" "worker-app-service" {
 name                    = "worker-app-service"
 location                = var.location
 resource_group_name     = var.resource_group_name
 app_service_plan_id     = azurerm_service_plan.appServiceLinux.id
 client_affinity_enabled = true
 site_config {
   scm_type  = "LocalGit"
   always_on = "true"

   linux_fx_version  = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/worker:latest" #define the images to usecfor you application

 }

 identity {
   type         = "SystemAssigned"
 }

 app_settings = {
   DOCKER_REGISTRY_SERVER_URL            = var.docker_registry_server_url
   DOCKER_REGISTRY_SERVER_USERNAME       = var.docker_registry_server_username
   DOCKER_REGISTRY_SERVER_PASSWORD       = var.docker_registry_server_password
 } 
}

resource "azurerm_app_service" "rng-app-service" {
 name                    = "rng-app-service"
 location                = var.location
 resource_group_name     = var.resource_group_name
 app_service_plan_id     = azurerm_service_plan.appServiceLinux.id
 client_affinity_enabled = true
 site_config {
   scm_type  = "LocalGit"
   always_on = "true"

   linux_fx_version  = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/rng:1.276" #define the images to usecfor you application

 }

 identity {
   type         = "SystemAssigned"
 }

 app_settings = {
      DOCKER_REGISTRY_SERVER_URL            = var.docker_registry_server_url
      DOCKER_REGISTRY_SERVER_USERNAME       = var.docker_registry_server_username
      DOCKER_REGISTRY_SERVER_PASSWORD       = var.docker_registry_server_password
 } 
}

resource "azurerm_redis_cache" "redis" {
  name                = "redis-dockercoins"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = true
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}

resource "azurerm_function_app" "hasher-function-app" {
  name                       = "hasher-function-app"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = azurerm_service_plan.appServiceLinux.id
  version = "~4"
  app_settings = {
      DOCKER_REGISTRY_SERVER_URL            = var.docker_registry_server_url
      DOCKER_REGISTRY_SERVER_USERNAME       = var.docker_registry_server_username
      DOCKER_REGISTRY_SERVER_PASSWORD       = var.docker_registry_server_password
  }
  site_config {
      linux_fx_version  = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/hasher:1.276" #define the images to usecfor you application
  }
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  
  lifecycle {
    ignore_changes = [
      site_config["linux_fx_version"] 
    ]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}