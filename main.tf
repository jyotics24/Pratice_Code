terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

####################
# Resource Group
####################
resource "azurerm_resource_group" "rg" {
  name     = "jenkins-tf-rg"
  location = "East US"
}

####################
# Virtual Network
####################
resource "azurerm_virtual_network" "vnet" {
  name                = "jenkins-tf-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

####################
# Subnet
####################
resource "azurerm_subnet" "subnet" {
  name                 = "jenkins-tf-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

####################
# Network Security Group
####################
resource "azurerm_network_security_group" "nsg" {
  name                = "jenkins-tf-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "JENKINS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

####################
# Public IP
####################
resource "azurerm_public_ip" "pubip" {
  name                = "jenkins-tf-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # Required for Standard SKU
  sku                 = "Standard"
}

####################
# Network Interface
####################
resource "azurerm_network_interface" "nic" {
  name                = "jenkins-tf-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

####################
# Linux VM (SSH-based)
####################
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "jenkins-tf-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  # Use SSH key instead of password
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

####################
# Outputs
####################
output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "public_ip_address" {
  value = azurerm_public_ip.pubip.ip_address
}

output "vm_admin_username" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}