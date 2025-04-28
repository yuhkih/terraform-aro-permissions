data "azurerm_client_config" "current" {}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

variable "subscription_id" {}

module "example" {
  source = "../../"

  installation_type = "api"

  # cluster parameters
  cluster_name        = "yuhki-api"
  vnet                = "example-aro-vnet-japaneast"
  vnet_resource_group = "example-vnet-rg"
  subnets = ["example-aro-control-subent-japaneast", "example-aro-worker-subent-japaneast"]
  #network_security_group = "dscott-api-nsg"
  aro_resource_group = {
    name   = "dscott-api-rg"
    create = true
  }


  # service principals
  cluster_service_principal = {
    name   = "yuhki-api-custom-cluster"
    create = true
  }

  installer_service_principal = {
    name   = "yuhki-api-custom-installer"
    create = true
  }

  # use custom roles with minimal permissions
  minimal_network_role = "yuhki-api-network"
  minimal_aro_role     = "yuhki-api-aro"

  # explicitly set subscription id and tenant id
  subscription_id = data.azurerm_client_config.current.subscription_id
  # subscription_id = var.subscription_id                                     
  tenant_id       = data.azurerm_client_config.current.tenant_id
}
