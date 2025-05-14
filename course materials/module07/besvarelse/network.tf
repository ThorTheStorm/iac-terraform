resource "azurerm_virtual_network" "vnet" {
    count               = var.vnet_instance_count
    name                = local.naming.vnet[count.index]
    resource_group_name = azurerm_resource_group.rg_network.name
    location            = azurerm_resource_group.rg_network.location
    address_space       = [local.networking.vnet_address_space[count.index]]
    tags                = local.common_tags
}

# Create a subnet within the vnet
resource "azurerm_subnet" "snet" {
    count                = var.vnet_instance_count * var.snet_instance_count
    name                 = local.naming.snet[count.index]
    virtual_network_name = azurerm_virtual_network.vnet[floor(count.index / var.snet_instance_count)].name
    address_prefixes     = [
        cidrsubnet(
        local.networking.vnet_address_space[floor(count.index / var.snet_instance_count)],
        var.snet_mask_offset,
        count.index % var.snet_instance_count
        )
    ]
    resource_group_name  = azurerm_resource_group.rg_network.name
}