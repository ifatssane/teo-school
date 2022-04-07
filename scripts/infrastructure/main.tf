#In Azure, all infrastructure elements such as virtual machines, storage, and our Kubernetes cluster need to be attached to a resource group.

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    zones               = ["1", "2", "3"]
    enable_auto_scaling = true
    max_count           = 4
    min_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
    network_policy    = "calico"
  }
}

resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    name = "monitoring"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_secret" "storage-secret" {

      metadata {
        name      = "thanos-objstore-config"
        namespace = "monitoring"
      }
      data = {
        "thanos.yml" = file("configuration/monitoring/storage.yml")
      }
  depends_on = [
    kubernetes_namespace.monitoring-namespace
  ]
}

resource "helm_release" "prometheus-operator" {
  chart      = "kube-prometheus-stack"
  name       = "prometheus-operator"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "34.9.0"
  values     = [file("configuration/monitoring/prometheus-operator-values.yml")]

  depends_on = [
    kubernetes_secret.storage-secret
  ]
}

resource "helm_release" "thanos" {
  chart      = "thanos"
  name       = "thanos"
  namespace  = "monitoring"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "10.3.2"
  values     = [file("configuration/monitoring/thanos-values.yml")]

  depends_on = [
    helm_release.prometheus-operator,
  ]
}