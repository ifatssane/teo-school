variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "docker_registry_server_url" {
  type        = string
  description = "Docker registry server URL"
}

variable "docker_registry_server_username" {
  type        = string
  description = "Docker registry server username"
}

variable "docker_registry_server_password" {
  type        = string
  description = "Docker registry server password"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account acces key"
}