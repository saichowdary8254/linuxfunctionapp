resource "azurerm_resource_group" "rg1" {
    name        = var.rg_name
    location    = var.rg_location
}

resource "azurerm_virtual_network" "vnet1" {
    name                    = var.vnet_name
    resource_group_name     = azurerm_resource_group.rg1.name #var.rg_name 
    location                = azurerm_resource_group.rg1.location #var.rg_location
    address_space           = var.address_space
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1_name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.address_prefix1
}

resource "azurerm_network_security_group" "ng1" {
  name                = var.nsg1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_network_security_rule" "rule1" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.ng1.name
}

resource "azurerm_network_interface_security_group_association" "nsgassoc" {
    network_interface_id = azurerm_network_interface.nic1.id
    network_security_group_id = azurerm_network_security_group.ng1.id
}

resource "azurerm_network_interface" "nic1" {
  name                = var.nic1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01.id
  }
}

resource "azurerm_public_ip" "pip01" {
    name                    = "devpip01"
    resource_group_name     = azurerm_resource_group.rg1.name
    location                = azurerm_resource_group.rg1.location
    allocation_method       = "Static"  
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = var.vm1_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
