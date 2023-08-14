package main

deny[msg] {
    input.kind == "azurerm_kubernetes_cluster"
    not has_tags(input)
    msg = "AKS cluster should have tags defined"
}

deny[msg] {
    input.kind == "azurerm_kubernetes_cluster"
    not has_network_policy(input)
    msg = "AKS cluster should have network policy enabled"
}

deny[msg] {
    input.kind == "azurerm_kubernetes_cluster"
    not has_fips_enabled(input)
    msg = "AKS cluster should have FIPS enabled"
}

deny[msg] {
    input.kind == "azurerm_kubernetes_cluster"
    not has_rbac_enabled(input)
    msg = "AKS cluster should have RBAC enabled"
}

has_tags(input) {
    input.metadata[0].tags
}

has_network_policy(input) {
    input.network_profile[0].network_policy
}

has_fips_enabled(input) {
    input.fips_enabled
}

has_rbac_enabled(input) {
    input.role_based_access_control
}
