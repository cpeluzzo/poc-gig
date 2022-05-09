resource "random_id" "poc" {
  byte_length = 3
}

resource "azurerm_resource_group" "poc" {
  name     = format("rg-%s%s", var.basename, random_id.poc.hex)
  location = var.location
  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_security_group" "poc" {
  name                = format("nsg-%s%s", var.basename, random_id.poc.hex)
  location            = azurerm_resource_group.poc.location
  resource_group_name = azurerm_resource_group.poc.name
  tags = {
    environment = var.tag
  }
}

resource "azurerm_virtual_network" "poc" {
  name                = format("vnet-%s%s", var.basename, random_id.poc.hex)
  location            = azurerm_resource_group.poc.location
  resource_group_name = azurerm_resource_group.poc.name
  address_space       = ["10.100.0.0/24"]

  tags = {
    environment = var.tag 
  }
}

resource "azurerm_subnet" "poc" {
  name                 = format("snet-%s%s", var.basename, random_id.poc.hex) 
  resource_group_name  = azurerm_resource_group.poc.name
  virtual_network_name = azurerm_virtual_network.poc.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_public_ip" "poc" {
  name                    = format("pip-%s%s", var.basename, random_id.poc.hex)
  location                = azurerm_resource_group.poc.location
  resource_group_name     = azurerm_resource_group.poc.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  sku                     = "Basic"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_interface" "poc" {
  name                = format("nic-%s%s", var.basename, random_id.poc.hex)
  location            = azurerm_resource_group.poc.location
  resource_group_name = azurerm_resource_group.poc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.poc.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.poc.id
  }
}

resource "tls_private_key" "poc" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "azurerm_key_vault_secret" "private" {
  name         = format("kvs-%s%s-pem", var.basename, random_id.poc.hex)
  value        = tls_private_key.poc.private_key_pem
  key_vault_id = data.azurerm_key_vault.poc.id

  tags = {
    environment = var.tag,
  }
}

resource "azurerm_linux_virtual_machine" "linux-basic" {
  name                = format("vm-%s%s", var.basename, random_id.poc.hex)
  resource_group_name = azurerm_resource_group.poc.name
  location            = azurerm_resource_group.poc.location
  size                = "Standard_B2s"
  admin_username      = var.uservm
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.poc.id
  ]

  admin_ssh_key {
    username   = var.uservm
    public_key = tls_private_key.poc.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }  
  
  tags = {
    Ansible = "Ubuntu"
    so = "linux"
    random = random_id.poc.hex
  }
}
