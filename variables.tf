variable "resource_group_name_prefix" {
  default       = "rg"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default       = "eastus"
  description   = "Location of the resource group."
}

variable "agent_count" {
    default = 2
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "myApp"
}

variable cluster_name {
    default = "myApp"
}

variable resource_group_name {
    default = "azure-myApp"
}

variable location {
    default = "East US"
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}

#variable "aks_service_principal_app_id" {}

#variable "aks_service_principal_client_secret" {}

variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}