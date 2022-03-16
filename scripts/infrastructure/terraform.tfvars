resource_group_name = "jaouad-aks-dockercoins"
location            = "westeurope"
cluster_name        = "dockercoins-cluster"
kubernetes_version  = "1.23.3"
system_node_count   = 2
acr_name            = "jaouadacr"

#To stock terraform state file in Azure Storage acount
resource_group_name_backend = "jaouad-aks-dockercoins-storage"
storage_account_name = "jaouadterraformstorage"
container_name = "jaouad-terraform-container"
key_backend = "terraform.tfstate"