# resource "azurerm_virtual_network" "dockercoinsNetwork" {
#   name                = "dockercoins-network"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = ["10.0.0.0/16"]

#   subnet {
#     name           = "frontend"
#     address_prefix = "10.0.1.0/24"
#   }

#   subnet {
#     name           = "backend"
#     address_prefix = "10.0.2.0/24"
#   }

#   tags = {
#     environment = "Dev"
#   }
# }

# resource "azurerm_public_ip" "frontendPublicIP" {
#     name                = "frontend-public-ip"
#     location            = var.location
#     resource_group_name = var.resource_group_name
#     allocation_method   = "Dynamic"

#     tags = {
#         environment = "Dev"
#     }
# }

# resource "azurerm_network_interface" "interfacePublicPrivate" {
#     name                 = "interface-public-private"
#     location            = var.location
#     resource_group_name = var.resource_group_name
#     enable_ip_forwarding = true

#     ip_configuration {
#     name                          = local.prefix-onprem
#     subnet_id                     = azurerm_subnet.onprem-mgmt.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.frontendPublicIP.id
#     }
# }

resource "azurerm_service_plan" "appServiceLinux" {
  name                = "docker-coins-app-service-plan-linux"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    environment = "Dev"
  }
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

    linux_fx_version = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/webui" #define the images to usecfor you application

  }

  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    REDIS_PASSWORD = azurerm_redis_cache.redis.primary_access_key
  }

  connection_string {
    name  = "redisConnectionString"
    type  = "RedisCache"
    value = azurerm_redis_cache.redis.primary_connection_string
  }

  depends_on = [
    azurerm_container_registry.acr
  ]

  tags = {
    environment = "Dev"
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

    linux_fx_version = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/worker" #define the images to usecfor you application

  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    REDIS_PASSWORD = azurerm_redis_cache.redis.primary_access_key
  }
  connection_string {
    name  = "redisConnectionString"
    type  = "RedisCache"
    value = azurerm_redis_cache.redis.primary_connection_string
  }
  depends_on = [
    azurerm_container_registry.acr
  ]

  tags = {
    environment = "Dev"
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

    linux_fx_version = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/rng" #define the images to usecfor you application

  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }
  depends_on = [
    azurerm_container_registry.acr
  ]

  tags = {
    environment = "Dev"
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

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_function_app" "hasher-function-app" {
  name                = "hasher-function-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_service_plan.appServiceLinux.id
  version             = "~4"
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }
  site_config {
    always_on = "true"
    linux_fx_version = "DOCKER|dockercoinsacr.azurecr.io/jaouadifatssane/hasher" #define the images to usecfor you application
  }
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  depends_on = [
    azurerm_container_registry.acr
  ]
  tags = {
    environment = "Dev"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "Dev"
  }
}

