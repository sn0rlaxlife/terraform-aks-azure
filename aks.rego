package main

import future.keywords

allowed_cni := [{"name": "calico"}]

resource_types := {"dns_service_ip", "ebpf_data_plane", "load_balancer_sku","network_plugin","network_plugin_mode","network_policy","network_profile","outbound_type","private_cluster_enabled"}

has_field(obj, field) {
	obj[field]
}

#walk the document tfplan.json
#and check that the network_plugin is set to calico
#and that the network_policy is set to calico
#and that the network_profile is set to to access
#r := rule {
	# Check that network_plugin is set to calico
#	deny contains msg if {
#		input.planned_values.root_module.child_modules[0].resources[1].values.network_profile[0] == "calico"
#		some network_policy in input.planned_values.root_module.child_modules[0].resources[1].values.network_profile[0]
#		contains("calico", network_policy, true)
#		msg := sprintf("Invalid network_plugin '%v' for azurerm_kubernetes_cluster resource", [network_policy])
#	}
#}


# Check that network_plugin is set to calico
#deny contains msg if {
#	input.planned_values.root_module.child_modules[0].resources[1].values.network_profile[0] == "calico"
#	some network_policy in input.planned_values.root_module.child_modules[0].resources[1].values.network_profile[0]
#	contains("calico", network_policy, true)
#	msg := sprintf("Invalid network_plugin '%v' for azurerm_kubernetes_cluster resource", [network_policy])
#}

# Test to check if network_policy has value "calico"  
deny[msg] {  
    netpol := resources[r].values.network_profile[0].network_policy  
    contains(netpol, "calico")  
    msg := sprintf("Invalid network_policy '%v' for azurerm_kubernetes_cluster resource. Expected 'azure'", [r.address])  
}  

# test to check if network_plugin has value "kubenet" - we want Azure CNI
deny[msg] {
	netcni := resources[r].values.network_profile[0].network_plugin
	contains(netcni, "kubenet")
	msg := sprintf("Invalid network_plugin '%v' for azurerm_kubernetes_cluster resource. Expected 'azurecni'", [r.address])
}

#check if private_cluster_enabled in azurerm_kubernetes_cluster is set to true
warn[msg] {
	pol := input.planned_values.root_module.child_modules[0].resources[1].values
	out := {"private_cluster_enabled": false};
	r contains "true" in out parse pol;
	msg := sprintf("Private cluster enabled for azurerm_kubernetes_cluster resource. This is not recommended", [pol.address])
	}


resources := { r |
    some path, value

    # Walk over the JSON tree and check if the node we are
    # currently on is a module (either root or child) resources
    # value.
    walk(input.planned_values, [path, value])

    # Look for resources in the current value based on path
    rs := module_resources(path, value)

    # Aggregate them into `resources`
    r := rs[_]
}
module_resources(path, value) := rs {
    # Expect something like:
    #
    #     {
    #     	"root_module": {
    #         	"resources": [...],
    #             ...
    #         }
    #         ...
    #     }
    #
    # Where the path is [..., "root_module", "resources"]

    reverse_index(path, 1) == "resources"
    reverse_index(path, 2) == "root_module"
    rs := value
}
# Variant to match child_modules resources
module_resources(path, value) := rs {
    # Expect something like:
    #
    #     {
    #     	...
    #         "child_modules": [
    #         	{
    #             	"resources": [...],
    #                 ...
    #             },
    #             ...
    #         ]
    #         ...
    #     }
    #
    # Where the path is [..., "child_modules", 0, "resources"]
    # Note that there will always be an index int between `child_modules`
    # and `resources`. We know that walk will only visit each one once,
    # so we shouldn't need to keep track of what the index is.

    reverse_index(path, 1) == "resources"
    reverse_index(path, 3) == "child_modules"
    rs := value
}

reverse_index(path, idx) := value {
	value := path[count(path) - idx]
}