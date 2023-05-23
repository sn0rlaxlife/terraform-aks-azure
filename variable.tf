variable "region" {
  type    = string
  default = "eastus"
}

variable "agents_size" {
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "os_sku" {
  type        = string
  default     = null
  description = "(Optional) Specifies the OS SKU used by the agent pool. Possible values include: `Ubuntu`, `CBLMariner`, `Mariner`, `Windows2019`, `Windows2022`. If not specified, the default is `Ubuntu` if OSType=Linux or `Windows2019` if OSType=Windows. And the default Windows OSSKU will be changed to `Windows2022` after Windows2019 is deprecated. Changing this forces a new resource to be created."
}

variable "pod_subnet_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Subnet where the pods in the default Node Pool should exist. Changing this forces a new resource to be created."
}

variable "private_cluster_enabled" {
  type        = bool
  default     = false
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to `false`."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, `System` to have AKS manage this or `None`. In case of `None` you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether public network access is allowed for this Kubernetes Cluster. Defaults to `true`. Changing this forces a new resource to be created."
  nullable    = false
}

variable "public_ssh_key" {
  type        = string
  default     = ""
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
}

variable "rbac_aad" {
  type        = bool
  default     = true
  description = "(Optional) Is Azure Active Directory integration enabled?"
  nullable    = false
}

variable "role_based_access_control_enabled" {
  type        = bool
  default     = false
  description = "Enable Role Based Access Control."
  nullable    = false
}


variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Standard`"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "The SKU Tier must be either `Free` or `Standard`. `Paid` is no longer supported since AzureRM provider v3.51.0."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Any tags that should be present on the AKS cluster resources"
}
