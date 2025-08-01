module "resource_group_name" {
    source = "../../modules/resource-group"
    resource_group = "preprod-rg"
    location = "westeurope"
  
}

module "resource_group_name1" {
    source = "../../modules/resource-group"
    resource_group = "rg_Ashish"
    location = "westus"
  
}

module "azurerm_virtual_network" {
    depends_on = [ module.resource_group_name ]
    source = "../../modules/Azurerm_vnet"
    azurerm_virtual_network = "preprod-vnet"
    location = "westeurope"
    resource_group = "preprod-rg"
    address_space = ["10.0.0.0/16"]

  
}
module "azurerm_fronted-subnet" {
    depends_on = [ module.azurerm_virtual_network ]
    source = "../../modules/azurerm_subnet"
    azurerm_subnet = "preprod-subnet"
    resource_group = "preprod-rg"
    virtual_network_name = "preprod-vnet"
    address_prefixes = ["10.0.1.0/24"]
  
}
module "azurerm_backend-subnet" {
    depends_on = [ module.azurerm_virtual_network ]
    source = "../../modules/azurerm_subnet"
    azurerm_subnet = "backend-subnet"
    resource_group = "preprod-rg"
    virtual_network_name = "preprod-vnet"
    address_prefixes = ["10.0.2.0/24"]
  
}

module "azurerm_fronted_public_ip" {
    depends_on = [ module.azurerm_virtual_network]
    source = "../../modules/azurerm_public_ip"
    azurerm_public_ip = "fronted_pip"
    resource_group_name = "preprod-rg"
    location = "westeurope"
    allocation_method = "Static"
  
}
module "azurerm_backend_public_ip" {
    depends_on = [ module.azurerm_virtual_network]
    source = "../../modules/azurerm_public_ip"
    azurerm_public_ip = "backend_pip"
    resource_group_name = "preprod-rg"
    location = "westeurope"
    allocation_method = "Static"
  
}
module "azurerm_fronted_vm" {
    source = "../../modules/azurerm_vm"
    depends_on =[ module.azurerm_fronted-subnet,module.azurerm_fronted_public_ip ]
    nic_name = "fronted-nic"
    location = "westeurope"
    resource_group = "preprod-rg"
    ip_name = "fronted-ip"
    subnet_id = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/preprod-rg/providers/Microsoft.Network/virtualNetworks/preprod-vnet/subnets/preprod-subnet"
    vm_name = "fronted-vm"
    size = "Standard_B1s"
    admin_username = "azureuser"
    admin_password = "P@ssw0rd1234!"
    image_publisher = "Canonical"
    image_offer = "0001-com-ubuntu-server-jammy"
    image_sku = "22_04-lts"
    image_version = "latest"
  
}

module "azurerm_backend_vm" {
    source = "../../modules/azurerm_vm"
    depends_on =[ module.azurerm_backend-subnet,module.azurerm_backend_public_ip ]
    nic_name = "backend-nic"
    location = "westeurope"
    resource_group = "preprod-rg"
    ip_name = "backend-ip"
    subnet_id = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/preprod-rg/providers/Microsoft.Network/virtualNetworks/preprod-vnet/subnets/backend-subnet"
    vm_name = "backend-vm"
    size = "Standard_B1s"
    admin_username = "azureuser1"
    admin_password = "P@ssw0rd12345!"
    image_publisher = "Canonical"
    image_offer = "0001-com-ubuntu-server-focal"
    image_sku = "20_04-lts"
    image_version = "latest"
  
}
module "sql_server" {
    source = "../../modules/azurerm_sql_server"
    sql_server_name = "preprod-sql-server"
    resource_group_name = "preprod-rg"
    location = "westeurope"
    administrator_login = "sqladmin"
    administrator_login_password = "P1234"

  
}
module "azurerm_sql_database" {
    source = "../../modules/azurerm_sql_database"
    db_name = "preprod-sql-db"
    server_id = module.sql_server.server_id
  
}
module "azurerm_key_vault" {
    source = "../../modules/azurerm_key_vault"
    key_vault_name = "preprod-key-vault"
    location = "westeurope"
    resource_group_name = "preprod-rg"
  
}
module "azurerm_key_vault_secret" {
    source = "../../modules/azurerm_key_vault_secret"
    secret_name  = "preprod-key-vault"
    secret_value = "P@ssw0rd1234!"
    
}




  




  


    




