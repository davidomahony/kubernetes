## The role of this page is to assign a managed identity to a pod to allow it to access resources from your subscriptions
## Documentation https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity

# Create the pod managed identity
resource "azurerm_user_assigned_identity" "pod_user_assigned" {
    depends_on = [
        kubernetes_namespace.namespace
    ]
    resource_group_name = local.resourceGroupName
    location            = local.location
    name                = "mi-${local.serviceName}"
}

# Create the Azure identity and link to managed identity
resource "kubectl_manifest" "promotion_api_identity" {
    depends_on = [
      kubernetes_namespace.namespace,
      azurerm_user_assigned_identity.pod_user_assigned
    ]
    yaml_body = <<YAML
      apiVersion: "aadpodidentity.k8s.io/v1"
      kind: AzureIdentity
      metadata:
        name: ${local.aadpodname}
        namespace: ${local.namespace}
      spec:
        type: 0
        resourceID: ${azurerm_user_assigned_identity.pod_user_assigned.id}
        clientID: ${azurerm_user_assigned_identity.pod_user_assigned.client_id}
      YAML
    override_namespace = local.namespace
}

# Create a binding for the azure identity
resource "kubectl_manifest" "promotion_api_identity_binding" {
    depends_on = [
        kubernetes_namespace.namespace,
        azurerm_user_assigned_identity.pod_user_assigned
    ]
    yaml_body = <<YAML
      apiVersion: "aadpodidentity.k8s.io/v1"
      kind: AzureIdentityBinding
      metadata:
        name: ${local.aadpodname}-binding
        namespace: ${local.namespace}
      spec:
        azureIdentity: ${local.aadpodname}
        selector: ${local.aadpodname}
      YAML
    override_namespace = local.namespace
}

# Give the new identity access
resource "azurerm_key_vault_access_policy" "key_vault" {
    depends_on = [
        kubernetes_namespace.namespace,
        azurerm_user_assigned_identity.pod_user_assigned
    ]
    key_vault_id = "${local.keyVaultId}"
    tenant_id    = "${local.tenantId}"
    object_id    = azurerm_user_assigned_identity.pod_user_assigned.principal_id

    key_permissions = [
        "Get",
        "List",
    ]

    secret_permissions = [
        "Get",
        "List",
    ]
}

