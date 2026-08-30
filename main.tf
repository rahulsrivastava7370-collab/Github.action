resource "azurerm_resource_group" "RGs" {
  name     = "MastecRG"
  location = "Central India"

}

resource "azurerm_resource_group" "RG2" {
  name     = "MastecRG2"
  location = "Central India"

}

resource "azurerm_resource_group" "RG3" {
  name     = "MastecRG3"
  location = "Central India"

}

resource "azurerm_storage_account" "storageaccount1" {
  name                     = "mastecstorageac"
  resource_group_name      = azurerm_resource_group.RGs.name
  location                 = azurerm_resource_group.RGs.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "storageaccount1" {
  name               = "mastecstorageaccountaconatiner"
  storage_account_id = azurerm_storage_account.storageaccount1.id

}

resource "azurerm_virtual_network" "VNET1" {
  name                = "mastecVNET"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RGs.location
  resource_group_name = azurerm_resource_group.RGs.name

}

resource "azurerm_subnet" "subnet1" {
  name                 = "mastecsubnet1"
  resource_group_name  = azurerm_resource_group.RGs.name
  virtual_network_name = azurerm_virtual_network.VNET1.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_subnet" "subnet2" {
  name                 = "mastecsubnet2"
  resource_group_name  = azurerm_resource_group.RGs.name
  virtual_network_name = azurerm_virtual_network.VNET1.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "publicip1" {
  name                = "mastecpip1"
  resource_group_name = azurerm_resource_group.RGs.name
  location            = azurerm_resource_group.RGs.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "nic1" {
  name                = "mastecnic1"
  location            = azurerm_resource_group.RGs.location
  resource_group_name = azurerm_resource_group.RGs.name

  ip_configuration {
    name                          = "mastecnic1ipconfig"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip1.id
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "mastecvm1"
  location              = azurerm_resource_group.RGs.location
  resource_group_name   = azurerm_resource_group.RGs.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_B2ats_v2"

  storage_os_disk {
    name              = "mastecvm1osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "mastecvm1"
    admin_username = "adminuser"
    admin_password = "Rahul@8210"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}






