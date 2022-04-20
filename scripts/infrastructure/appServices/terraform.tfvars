resource_group_name = "jaouad-aks-dockercoins"
location            = "westeurope"
cluster_name        = "dockercoins-cluster"
kubernetes_version  = "1.23.3"
system_node_count   = 3
acr_name            = "dockercoinsacr"
docker_registry_server_url            = "https://dockercoinsacr.azurecr.io"
docker_registry_server_username       = "dockercoinsacr"
docker_registry_server_password       = #{DOCKER_REGISTRY_SERVER_PASSWORD}#
storage_account_name       = "jaouadterraformstorage"
storage_account_access_key = "ea+F7L5c5y3JZORuLtST7ZO5ANKtmeJJ9+/wh5gOy0ydCEEgbwZo4NhbzY5U5RLaawUZKNaSCBqimSwPlSELjA=="
  