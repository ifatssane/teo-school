resource_group_name = "jaouad-aks-dockercoins"
location            = "westeurope"
cluster_name        = "dockercoins-cluster"
kubernetes_version  = "1.23.3"
system_node_count   = 3
acr_name            = "dockercoinsacr"
#docker_registry_server_url            = "https://dockercoinsacr.azurecr.io"
#docker_registry_server_username       = "dockercoinsacr"
#docker_registry_server_password       = #{DOCKER_REGISTRY_SERVER_PASSWORD}#
storage_account_name       = "dockercoinsstorage"
storage_account_access_key = "#{STORAGE_ACCOUNT_ACCESS_KEY}#"

